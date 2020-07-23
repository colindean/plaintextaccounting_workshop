# Querying your Transaction Records with Reports

There are two types of basic reports in `ledger`:

* `balance` - applies all transactions and displays the current balance
* `register` - applies all transaction and displays each transaction in a list

Write the contents of @lst:basics_basic to a file `1.ledger`.

## Balance reports {#sec:reports_balance}

Balance reports display balances in a a convenient account tree format.
This format enables you to see what amounts are associated with what accounts
in a clear summary view.

Run `ledger --file 1.ledger balance` to see a balance report.
It should look like the contents of @lst:basics_balance.

::: protip

**PROTIP**: Note that `-f` and `--file` are synonymous and used interchangeably throughout
this workshop.
There may be other short options, i.e. one character preceded by one dash, used in place of
other long option, i.e. two dashed preceding a word or a couple of words.
It's a good practice to use long options when writing a script and short
options when when typing a command in a terminal.
Not all programs offer both for each option, so keep your eyes out!
Fortunately, most CLI options in `ledger` do have a short and long version.

:::

Listing: Balance report for @lst:basics_basic {#lst:basics_balance}

```{pipe="sh"}
ledger -f root/examples.ledger balance --begin 2017/06/26 --end 2017/06/27
```

@Lst:examples shows a more realistic transaction log. Write it to a file
`ex.ledger` so that you can use it for some querying experimentation.

Listing: A fuller example (`ex.ledger`) {#lst:examples}

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

Listing: Account tree effects (`account_tree_effects.ledger`) {#lst:account_tree_effects}
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

::: protip

**PROTIP:** It's a good idea to post transactions to the leaf accounts or subaccounts.

:::

Listing: Balance report on `account_tree_effects.ledger` {#lst:account_tree_effects_balance}
```{pipe="ledger -f account_tree_effects.ledger bal" .numberLines}
```

Note that when an account has only one subaccount, that subaccount is displayed
inline, but multiple subaccounts are broken out into multiple lines.

The zero at the bottom of a balance report indicates a zero net balance across all of the queries accounts.
If you were tracking price changes on a commodity like a stock, this could be positive or negative.
More on that in @sec:commodities.

## Register report

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
ledger -f 1.ledger register
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

::: protip

**PROTIP:** Now is a great time to widen your terminal window to at least 120 columns.

:::
