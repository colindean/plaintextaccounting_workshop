# Importing Data from Your Financial Institutions

## Using `ledger-autosync` to convert bank records

`ledger-autosync` is a fantastic tool that drastically expedites data entry by almost entirely automating it.

### Cleaning data {#sec:sync_clean}

If you're lucky, your bank will provide an export in QFX or OFX format.
`ledger-autosync` handles this excellently and needs little manual preparation.
However, not all do – only four of this author's seven financial institutions
do – so you will inevitably need to deal with CSV.

First, you need to understand CSV, character- or comma-separated value format. If you've never encountered it, you're probably early in your journey in computer science and consuming data.
CSV uses a character, generally a comma (`,`) to separate fields in a record of data, and another character, generally a newline, to separate the records.
Fields are optionally contained within paired quotation marks (`"`) in order to
allow commas and newlines to be "escaped" and exist within the field.
Other common field separators are tabs, pipes (`|`), and the actual unit separator character (ASCII 31), while the record separator is almost always a newline but is sometimes the record separator character (ASCII 30). There are a variety of [delimiters](https://en.wikipedia.org/wiki/Delimiter) in CSV, but it's important to think in commas, quotation marks, and newlines most of the time.

Despite being often created by CSV libraries, sometimes CSV isn't cleanly parseable. Again, if you don't already know this, you will learn in the process of maintaining your finances that CSV is the worst format ever and that you should avoid it at all costs, both as a consumer and a producer [^bidhigh].

[^bidhigh]: If someone ever asks you how much it will cost to ship CSV as a part of a product, bid high.

For example, Simple, one of my banks, emits CSV that Python's CSV library cannot reliably automatically determine its delimiter. So I use a convenient tool called `xsv` to sort it (because it comes in reverse order) and then add quotation marks explicitly in `clean_simple.sh`, shown in @lst:cleancsv.

Listing: `clean_simple.sh` {#lst:cleancsv}

```{.bash pipe="tee clean_simple.sh"}
#!/usr/bin/env bash
INPUT="$1"
xsv sort --select Date "${INPUT}" | \
  xsv fmt --quote-always > \
    "$(basename -s .csv "${INPUT}")-sorted.csv"

```

```{pipe="sh"}
cp root/simple.csv simple.csv
```

::: tryit

**TRY IT:** In the supplementary artifacts provided in @sec:artifacts, there is
a file `simple.csv`.
Run @lst:cleancsv on it with `bash clean_simple.sh
simple.csv` to fix the data so that `ledger-autosync` can read it.
The output will be written to `simple-sorted.csv`.

:::


### Updating a transaction record with new data {#sec:autosync_updates}

`ledger-autosync` uses a _transaction ID_ to uniquely identify transactions.
When importing from QFX files, this transaction ID is provided by the exporting bank and _should_ always be trustworthy.
When importing from CSV files, `ledger-autosync` must derive the transaction ID from the data if the definition of the format being read does not identify a transaction ID provided in the data.
The derived transactions ID is a hash of all of the data in the row concatentated together.
@Lst:csvid shows an example of how `ledger-autosync` does this.

Listing: Python example showing how row IDs are generated {#lst:csvid}

```python
from functools import reduce
import hashlib
# `row` is a list containing the columns from a single row
smushed_row = reduce(lambda a,b: a + b, row).encode('utf-8')
csv_id = hashlib.sha256(smushed_row).hexdigest()
```

Run `ledger-autosync` once on your clean, exported CSV from @sec:sync_clean to visually check the output using the command in @lst:export_show.

Listing: `ledger-autosync` running on `simple-sorted.csv` {#lst:export_show}

```bash
ledger-autosync \
    -a "Assets:Cash:Banks:Simple:Checking" \
    -l 2020.ledger \
    --unknown-account "Equity:Unknown" \
    simple-sorted.csv
```

Then, run it again, but this time _append_ to your existing transaction record using output redirection `>>`, as shown in @lst:export_append.

Listing: Appending the output of `ledger-autosync` to a file {#lst:export_append}

```bash
ledger-autosync \
    -a "Assets:Cash:Banks:Simple:Checking" \
    -l 2020.ledger \
    --unknown-account "Equity:Unknown" \
    simple-sorted.csv >> 2020.ledger
```

If you run @lst:export_append again, you'll notice that nothing else new was added! `ledger-autosync` successfully used the CSVID it generated to keep from adding transactions it already had converted.

## Rules to keep in mind for synchronizing

1. Synchronize your primary account first.
2. Synchronize transfer or payment IDs from subsequent accounts that have transfers or payments to or from that primary account _before_ mixing in the other accounts' full records. This ensures that you are tracking both records' IDs in order to prevent duplicate entries. You can _manually_ delete the transfer or payment transactions from your initial conversion against your primary ledger file or you can re-run `ledger-autosync` and it will ignore the IDs that are already present in the ledger file passed as `--ledger`.
3. Diligently use `; AutosyncPayee: XXX` tags in transactions where you modify the payee. This will enable `ledger-autosync` to find transactions and set the counter-transaction (the expense, generally) automatically. This will save you literally hours of data entry per update session!
4. Use your editor's autocomplete functionality. [`vim-ledger`](https://github.com/ledger/vim-ledger) lends itself to this with its `Ctrl-X Ctrl-O` autocompletion trigger while in insert mode: it'll look at all account names in the current file by doing `ledger -f - accounts` and build suggestions based on partial matches. `E:E:B` could expand to `Expenses:Electronics:Batteries`. Look how much time that saves in typing alone!

## Converting with `ledger`

Importing with `ledger` is possible through its `convert` command.
However, it takes a lot of massaging of data to use.
It lends itself to scripting, but those scripts are not as easy to share as
`ledger-autosync`'s plugins. This author has contributed some of the converters
available in `ledger-autosync`.

If you're interested in learning how to convert using only `ledger`, check out
the [`convert` command section](https://www.ledger-cli.org/3.0/doc/ledger3.html#The-convert-command) in the `ledger` docs.
This section is thorough and well-explained.

## Experimentation

::: tryit

**TRY IT:**
Retrieve exports from your financial institution perhaps from a bank like
Simple.
Try different ways of converting them automatically or try entering
a few transactions by hand.

:::

You may find that you need to implement a converter plugin for
`ledger-autosync`. See the [Plugin Support](https://github.com/egh/ledger-autosync#plugin-support) documentation for how to write in Python a new `CsvConverter` subclass that the program can load and use.
Use the [built-in converters](https://github.com/egh/ledger-autosync/blob/cc6d9f61420c69d08d5b7d6d529f28c5da20cf47/ledgerautosync/converter.py#L597-L929) as inspiration or ask the author of this workshop for advice – he's implemented many converters!

## The tedium: categorizing transactions using accounts in your account tree {#sec:categorizing}

Now that you've got some data, you're onto the tedious task of categorizing transactions by replacing the `Equity:Unknown` account with something meaningful. If you need an idea of some accounts to use, see @sec:fin_acct_ref, which contains a list of accounts this author has used in some form.

Don't worry too much about formatting. We'll use `ledger` itself to reformat and sort the transactions you're modifying.

It might be helpful to have a little program showing you what transactions remain to be categorized. [`entr`](http://eradman.com/entrproject/) is a great little tool for watching files for changes and running a command when they change. @lst:entr shows a command that runs a `ledger` register report in wide mode on `2020.ledger` showing only the `Equity:Unknown` account postings whenever `2020.ledger` changes.

Listing: Automatically run ledger whenever `2020.ledger` changes {#lst:entr}

```bash
echo 2020.ledger | entr -acpr ledger -w -f /_ reg Equity:Unknown
```

## Deduplicating inter-account transfers

Inevitably, you'll have a transfer that touches two exports, for example a credit card payment that appears on both your bank statement and your credit card statement.
@Lst:dedup-before shows what this can look like in your transaction record.
You'll have to manually deduplicate them until [egh/ledger-autosync#101](https://github.com/egh/ledger-autosync/issues/101) is in and `ledger-autosync` is smarter about detecting possible transfers!

Listing: Transaction record before deduplication {#lst:dedup-before}

```ledger
2019/03/28 AUTOPAY THANK YOU
    ; ofxid: 2102.XXXXXXXXXXXX2321.20190328090097
    Liabilities:CreditCard:Citi:Costco    742.82 USD = 0.00 USD
    Assets:Cash:Banks:Dollar:Checking

2019/03/29 ECK CITIBANK PAYMENT
    ; csvid: bc0c96d0c2aae6830cbfd20d8baf6c59
    Assets:Cash:Banks:Dollar:Checking    -742.82 USD = 1,400.23 USD
    Liabilities:CreditCard:Citi:Costco
```

@Lst:dedup-after shows the appropriate way to combine them.

Listing: Transaction record after deduplication {#lst:dedup-after}

```ledger
2019/03/28=2019/03/29 Citibank Costco Visa Payment
    ; csvid: bc0c96d0c2aae6830cbfd20d8baf6c59
    Assets:Cash:Banks:Dollar:Checking    -742.82 USD = 1,400.23 USD
    ; ofxid: 2102.XXXXXXXXXXXX2321.20190328090097
    Liabilities:CreditCard:Citi:Costco    742.82 USD = 0.00 USD
```

Note the date initialized and date cleared notation. This can be helpful to know when the transaction was started and when it actually completed. `ledger` generally knows how best to handle this internally when building its model of record.

Note that the comment is in tag format and is above the posting it annotates. Dollar Bank gives me CSV while Citi gives me OFX. If I were run an import again against either export file, `ledger-autosync` _should_ catch it and not duplicate the transaction.

Balance assertions are "hard mode" for `ledger`. While they can really help you checkpoint, they can be difficult to work with because of how they are processed. BAs are processed in _transaction record appearance order_, not in date order. When sorting, the transaction date is used, not the clearing date. This means that a BA might be off after sorting. I use a mental rule that as long as a BA worked before sorting, it's _probably_ safe to comment it out after sorting if it's causing problems because of transaction date ordering.

## Protips for categorizing quickly and efficiently

This is the most laborious part of tracking your finances in _any_ accounting system, so you really want to find ways to optimize your workflow to _incentivize_ you to do it. Manual entry is the most rewarding yet tedious way to do this, so automating typing – especially when it comes transaction _amounts_ – is imporant to reduce the error-prone parts so you can focus your manual time on the categorization that is sometimes difficult to automate.

When trying to figure out how to categorize transactions from the same vendor, try to **remember patterns in your spending**. For example, when a transaction is from a gas station and it's under $10.00, it's probably coffeee, so I categorize it as `Expenses:Coffee` because I track that separate from my `Expenses:Restaurants` when my primary reason for the purchase is, uh, go-go bean juice. If the gas station charge is between $20 and $40, it's 95% likely refueling my car with a 10 gallon tank. If the charge is over that, it's probably for my big SUV with its 25 gallon tank.

**Make progress** when categorizing. If you can't figure out what a transaction is from the cryptic information your bank gives you, mark it with something and move on, e.g. `Equity:Unknown` for bank transaction records or `Expenses:Stuff` for credit card records. These two things help me mark transactions for which I need to look at receipts or go back to the bank's  activity records or statement to see if I can get more context about the purchase.

**Use indicators in the cents of tipped charges** to help you remember what it was at a restaurant. For example, if you want to categorize a transaction as a restaurant charge, tip such that the total is something like $31.03, where 3¢ means it's `Expenses:Restaurant`. If you want to remind yourself that it's alcohol-only, make the total something like $31.04, where 4¢ means that it should be `Expenses:Alcohol`. You can even program an autoclassification tool to handle this for you at some step in your categorization workflow.

## Reformatting with a sort

`ledger` contains a simple `print` command that writes transactions out in the most storage-efficient format possible. It can also use queries to limit what's printed or it can sort the output. Since our appended transactions may be out of order, let's use the opportunity to sort them by date, which is indicated by `d` in `ledger`'s format specifier syntax.

It's a good idea to ensure that you've committed before doing this in case the sort messes up. @Lst:sorting shows how to safely sort.

Listing: Sorting safely with ledger {#lst:sorting}

```bash
ledger -f 2020.ledger --sort d print > 2020-s.ledger
mv 2020-s.ledger 2020.ledger
ledger -f 2020.ledger bal
```

If the sort worked and didn't alter your output, then commit again!

We have to do file rename dance because `ledger` reads in a stream and outputs immediately, so we'd risk overwriting our log file!

