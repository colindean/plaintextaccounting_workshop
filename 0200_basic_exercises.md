# Ledger Basics

This part of the workshop will teach you the basic format of a `ledger`
transaction record and basic command line usage of the `ledger` program.

## Maintaining your Transaction Record in `ledger` format

Tracking your transactions for analysis with `ledger` is as easy as writing some text to a file in a very human-readable format.
The format is _structured_ but appears _unstructured_ to many because it doesn't use curly brackets, key-value pairs, or other special characters to model transaction data.
Instead, the things that matter are just having enough whitespace between
certain elements in order for the `ledger` parser to understand the difference
between dates, amounts, and so on.

Start your favorite text editor and terminal emulator [^Terminal, iTerm2,
etc.] and you'll get started on the path to personal finance greatness.

### Basic transaction format

Recall from the introductory presentation in @sec:intro_talk the basic format
of a `ledger` transaction, shown in @lst:basics_basic.

Listing: A basic transaction {#lst:basics_basic}

```{.ledger include="examples.ledger" startLine=8 endLine=10 .numberLines}
```

In @lst:basics_basic, line 8 shows the _transaction date_ and _payee_.
Lines 9 and 8 shows a _posting_ comprised of an _account_ and an _amount_.

All transactions must balance. That is, the amount credited must
equal the amount debited: credits minus debits must equal zero.

Note the _accounts_ used in this example.
One begins with `Expenses` and the other begins with `Assets`.
Expenses are _credited_ because the money flows _toward_ them.
Assets are credited when you add funds and debited when you move money to something else.
In this transaction, you're deducting money from an account representing your wallet and adding it to an expense representing your coffee spending.

`ledger` has some great conveniences that ease entry.
One such convenience is that `ledger` allows transactions to omit the _amount_ on a single _posting_, as shown in @lst:basics_basic_omitamount.
The missing amount is calculated and is equal to whatever amount is necessary
to balance the transaction.

Listing: A basic transaction with an automatically-balanced posting amount {#lst:basics_basic_omitamount}

```{.ledger include="examples.ledger" startLine=12 endLine=14 .numberLines}
```

You can also supply comments for a transaction or posting.
Postings can only have one comment line but transactions can have as many as
you want.
A comment in the format `key: value` creates a transaction _tag_ accessible in
queries. You'll learn more about that in @sec:querying_tagged_transactions.

Listing: A basic transaction with a comment {#lst:basics_basic_comment}

```{.ledger include="examples.ledger" startLine=16 endLine=19 .numberLines}
```

## Querying your Transaction Records with Reports

There are two types of basic reports in `ledger`:

* `balance` - applies all transactions and displays the current balance
* `register` - applies all transaction and displays each transaction in a list

Write the contents of @lst:basics_basic to a file `1.ledger`.

### Balance reports

Balance reports display balances in a a convenient account tree format.
This format enables you to see what amounts are associated with what accounts
in a clear summary view.

Run `ledger --file 1.ledger balance` to see a balance report.
It should look like the contents of @lst:basics_balance.

Listing: Balance report for @lst:basics_basic {#lst:basics_balance}

```{pipe="sh"}
ledger -f root/examples.ledger balance --begin 2017/06/26 --end 2017/06/27
```

@Lst:examples shows a more realistic transaction log. Write it to a file
`examples.ledger` so that you can use it for some querying experimentation.

Listing: A fuller example {#lst:examples}

```{pipe="sh | ledger -f - print | tee ex.ledger"}
cat root/examples.ledger
```

Run `ledger -f ex.ledger balance` to see the balance report.
@Lst:examples_bal reflects what you'll see.

Listing: Examples basic balance report {#lst:examples_bal}
```{pipe="sh" }
ledger -f ex.ledger balance
```

Notice the structure of the output in @lst:examples_bal.
This account tree structure helps the reader understand the sum of each account
at the level shown. Leaves on the tree show the amount just for the account,
while higher-level accounts sum all of the leaves and may include postings at
that particular level.

To see this more in action, check out the transactions in
@lst:account_tree_effects. Notice that the posting on line 5 is to an account
that other postings have used a subaccount.

Listing: Account tree effects {#lst:account_tree_effects}
```{.ledger pipe="tee account_tree_effects.ledger" .numberLines}
2020/07/01 Black Forge Coffee
  Expenses:Restaurants:Coffee   5
  Liabilities:CreditCard:Visa

2020/07/02 Leon's Caribbean
  Expenses:Restaurants          20
  Liabilities:CreditCard:Amex

2020/07/04 Lorelei
  Expenses:Restaurants:Alcohol  10
  Liabilities:CreditCard:Visa
```

@Lst:account_tree_effects_balance shows the balance report on these transactions.
Note that the `Expenses` on line 1 reflects credits of 35 and while the sum of the leaf
accounts is only 25. Note that the sum of the leaf accounts in `Liabilities` on
line 4 is 35.

**PROTIP:** It's a good idea to post transactions to the leaf accounts or subaccounts.

Listing: Account tree effects balance report {#lst:account_tree_effects_balance}
```{pipe="ledger -f account_tree_effects.ledger bal" .numberLines}
```

Note that when an account has only one subaccount, that subaccount is displayed
inline, but multiple subaccounts are broken out into multiple lines.

The zero at the bottom of a balance report indicates a zero net balance across all of the queries accounts.
If you were tracking price changes on a commodity like a stock, this could be positive or negative.
More on that in @sec:commodities.

### Register report

The register report lists all transactions that match your query.
This is useful for comparing against a bank statement or other list of
transactions when reconciling your records against those provided by a third party.
Bank transaction errors seem to be a rarity these days, but manually reviewing
even after importing transactions manually is an excellent way to ensure that
no transactions were omitted or have incorrect information.
The register is a great way to see all transactions involving a certain account
or payee or date. You'll learn more about this in [@sec:querying_accounts,
@sec:querying_payees, @sec:advanced_queries].

To see a register report for the transasction shown in @lst:basics_basic,
run `ledger --file 1.ledger register`.
It should look like the contents of @lst:basics_register.

Listing: Register report for @lst:basics_basic {#lst:basics_register}

```{pipe="sh"}
ledger -f root/examples.ledger register --begin 2017/06/26 --end 2017/06/27
```

Register reports on a single transaction are pretty boring, so
run `ledger -f ex.ledger register` to see the register report for @lst:examples
and it should match @lst:examples_reg.

Listing: Examples basic register report {#lst:examples_reg}
```{pipe="sh"}
ledger -f ex.ledger register
```

You'll notice this minimal output in @lst:examples_reg is more simplified than
what you're likely seeing in your terminal. `ledger` elegantly determines the
width of your terminal and makes an attempt to size the display accordingly.
You can add `--wide` to the command invocation in order to force a wide view.
This is useful for generating reports that will be on HTML documents or other
hypermedia that is less sensitive to width.

Notice the dates, the payees, and the postings. The first column of numbers is
the amount for each posting while the second number reflects a running sum
_within the query_ of each account shown. Notice also that the account names
are abbreviated: this is a result of the aforementioned width limitation.
It really is a good idea to use `ledger` on a wide terminal, at least 120
columns. Run `echo $COLUMNS` and you'll likely see your current column width.

**PROTIP:** Now is a great time to widen your terminal window to at least 120 columns.

## Querying Accounts {#sec:querying_accounts}

## Querying Payees {#sec:querying_payees}

## Focusing Queries in Other Ways {#sec:advanced_queries}

## Other Reports

* `cleared` : Shows a special `balance` view that more visibly shows balances
              when there are transactions that have not yet cleared, e.g. a
              check is in the mail.
* `equity`: Prints current account balances as a single transaction.
            Useful for summarizing previous years as an opening balances
            transaction on a fresh ledger.


## Keeping a Tidy Transaction Log

* `print` : Prints all transactions nicely formatted with the minimal text
            necessary to represent the transaction. Useful for sorting
            transactions that were entered out of order.

## Exporting for Other Programs


While the Plain Text Ecosystem has a lot of useful tools,
a few other commands facilitate interacting with other programs.

* `csv` : Outputs transactions in CSV format.
* `xml` : Outputs transactions in XML format.
