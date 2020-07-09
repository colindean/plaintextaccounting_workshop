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
Then, run `ledger --file 1.ledger balance` to see balance report.
It should look like the contents of @lst:basics_balance.

Listing: Balance report for @lst:basics_basic {#lst:basics_balance}

```{pipe="sh"}
ledger -f root/examples.ledger balance --begin 2017/06/26 --end 2017/06/27
```
Then, run `ledger --file 1.ledger register` to see the register report.
It should look like the contents of @lst:basics_register.

Listing: Register report for @lst:basics_basic {#lst:basics_register}

```{pipe="sh"}
ledger -f root/examples.ledger register --begin 2017/06/26 --end 2017/06/27
```

@Lst:examples shows a more realistic transaction log. Write it to a file
`examples.ledger` so that you can use it for some querying experimentation.

Listing: A fuller example {#lst:examples}

```{pipe="sh | ledger -f - print | tee ex.ledger"}
cat root/examples.ledger
```

Run `ledger -f ex.ledger balance` to see the balance report and
run `ledger -f ex.ledger register` to see the register report.
@Lst:examples_bal and @lst:examples_reg reflect what you'll see.

Listing: Examples basic balance report {#lst:examples_bal}
```{pipe="sh" }
ledger -f ex.ledger balance
```

Listing: Examples basic register report {#lst:examples_reg}
```{pipe="sh"}
ledger -f ex.ledger register
```

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
