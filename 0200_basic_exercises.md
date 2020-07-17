# Maintaining your Transaction Record in `ledger` format

Tracking your transactions for analysis with `ledger` is as easy as writing some text to a file in a very human-readable format.
The format is _structured_ but appears _unstructured_ to many because it doesn't use curly brackets, key-value pairs, or other special characters to model transaction data.
Instead, the things that matter are just having enough whitespace between
certain elements in order for the `ledger` parser to understand the difference
between dates, amounts, and so on.

Start your favorite text editor and terminal emulator [^terminals] and you'll get started on the path to personal finance greatness.

[^terminals]: Command Prompt, Terminal, iTerm2, Gnome Terminal, Alacritty, etc.

## Basic transaction format {#sec:basic_tx_format}

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
queries. You'll learn more about that in @sec:tx_walkthrough and @sec:querying_tagged_transactions.

Listing: A basic transaction with a comment {#lst:basics_basic_comment}

```{.ledger include="examples.ledger" startLine=16 endLine=19 .numberLines}
```

## Walkthrough of some common basic transactions {#sec:tx_walkthrough}

There are some other important things to highlight about transaction formatting.
@lst:common_transactions lists a few common example transactions worth explaining.

Transactions have a state noting that they are uncleared, pending, or cleared.
This is useful to note transactions that you may need to revisit and amend,
such as outstanding checks or other similar payments.

* Line 1: The presence of `!` marks a transaction as pending.
* Line 6: The presence of `*` marks a transaction as cleared.
* Line 11: The absence of a mark leaves a transaction in uncleared state.

These can apply to individual postings, too, as is shown on line 14 to indicate
that payment was made on July 15 but it's not expected to hit your bank account
until July 23.

Note the comments on lines 2, 7, and 12 are in the `key: value` format
mentioned in @sec:basic_tx_format.

Lastly, note the presence of `USD` after the amounts in each posting.
This denotes the currency by creating a commodity implicitly.
`ledger` tracks all currencies, like US Dollar, the Euro, Haitian gourde,
Bitcoin, or Japanese yen, and things like stocks, property, and more with a
commodity.
It is essentially a label to distinguish balances in different systems and
different amounts of a different object!
You'll learn more on commodities in @sec:commodities.

Listing: Common transaction examples {#lst:common_transactions}

```{.ledger pipe="ledger -f - print | tee walkthrough.ledger" .numberLines}
2020-07-15 ! PA Department of Revenue Income Tax Due
  ; check_number: 1701
  Expenses:Taxes:EarnedIncome:Pennsylvania    64.00 USD
  Assets:Cash:Banks:Dollar                   -64.00 USD

2020-07-17 * Code and Supply Heartifacts Tickets
  ; ticket_reference: 0xDECAFBAD
  Expenses:Conferences:Registration    50.00 USD
  Liabilities:CreditCard:Visa         -50.00 USD

2020-07-15=2020-07-23 IRS Tax Due
  ; check_number: 1700
  * Expenses:Taxes:EarnedIncome:Federal    64.00 USD
  ! Assets:Cash:Banks:Dollar              -64.00 USD

```

