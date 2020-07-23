# Tracking Multiple Currencies, Stocks, and Other Commodities {#sec:commodities}

## What is a Commodity?

You were first introduced to commodities in @sec:tx_walkthrough.
In that section, the `USD` suddenly introduced in the examples
denoted the currency by creating a commodity implicitly.
Remember that `ledger` tracks all currencies, such as
the US Dollar ($ - USD),
the Euro (€ - EUR),
<!-- figure out how to get a version of Source Serif Pro with these -->
the Armenian dram (֏ - AMD),
Bitcoin (₿ - BTC), or
the Ethiopian birr (Br - ETB),
and things like stocks, property, and more with a commodity.
The commodities are simply label to distinguish balances in different systems;
they note different amounts of a different object!

<!--
Note: this section borrows _heavily_ from the
[Currency and Commodities section of the Ledger CLI 3.0 Documentation](https://www.ledger-cli.org/3.0/doc/ledger3.html#Currency-and-Commodities) (@ledger:docs), which
contains excellent examples of common commodity-tracking workflows.
-->

## Explicitly Defining Commodities in `ledger`

It is a good practice to explicitly note your primary commodity at the top of
your `ledger` transaction record when you may have multiple commodities.
`ledger` defines some _directives_ that are used to declare things.
One such is a `commodity` directive, as shown in @lst:commodity_directive.
These directives allow you to define aliases between commodities and to
designate the format to use when displaying an amount in that particular
commodity.

Listing: A couple of common commodity directives {#lst:commodity_directive}

```{.ledger}
commodity USD
  note "US Dollar"
  alias $
  format 1,000.00
  default

commodity VTSAX
  note "Vanguard Total Stock Market Index Admiral Shares"
  format 1,000.0000

commodity BTC
  note "Bitcoin"
  format 1,000.00000000

commodity mBTC
  note "millibitcoin"
  format 1,000.0000

; denotes a commodity conversion
C 1000.0000 mBTC = 1.000000 BTC
```

Note that these really come in handy when using `--strict` or `--pedantic`
modes.
In these modes, accounts, tags, and commodities not previously declared
will be declared as warnings or errors, respectively (@ledger:docs).

Commodities can also have a space in them, so you can track commodities without
abbreviating them, as well. For example, when [Code & Supply Scholarship
Fund](https://codeandsupply.fund) was donated tickets for [Abstractions
II](https://abstractions.io) software conference, this author tracked those
donations as inventory in the non-profit organization's `ledger` records as
shown in @lst:abstractions_tix.

Listing: Tracking inventory with `ledger` (`tickets.ledger`) {#lst:abstractions_tix}

```{.ledger pipe="ledger -f - print | tee tickets.ledger"}
2019-07-24 * Ticket Donation from Numerius Negidius
  Income:Donations:InKind     -1 "Abstractions II Ticket"
  Assets:Tickets

2019-07-25 * Ticket Award to Aulua Agerius
  Assets:Tickets              -1 "Abstractions II Ticket"
  Expenses:Program:Tickets
```

## Recording Commodity Transactions {#sec:commodity_recording}

Recording in multiple currencies is easy when you know precisely the
exchanged amounts. @lst:simple_multicurrency and its balance report in
@lst:simple_multicurrency_bal show this.

Listing: A simple pair of multi-currency transactions (`multicurrency.ledger`) {#lst:simple_multicurrency}

```{.ledger pipe="ledger -f - print | tee multicurrency.ledger"}
2013-01-31 * Duty Free Currency Exchange
  Assets:Cash:Bank:Checking   -50.00 USD
  Assets:Cash:Wallet           250.00 CRC ; Costa Rican Colónes

2013-02-01 * Plaintains
  Expenses:Groceries          2 CRC
  Assets:Cash:Wallet

```

Listing: Balance report on @lst:simple_multicurrency {#lst:simple_multicurrency_bal}

```{pipe="sh"}
ledger -f multicurrency.ledger bal

```

Recording the purchase of stock or something else that works like stock, e.g.
cryptocurrency, is best done by denoting the purchase price and any commissions
or other purchase fees explicitly, then showing the debit in the amount paid.
This is a great check on the math of the institution from which you purchased
the commodity.
In fact, this author has caught small math bugs and keeps a running account
called `Equity:RoundingErrors` just to capture small differences in reported
and actual math.

Listing: Buying some Bitcoin and tracking with `ledger` (`bitcoin.ledger`) {#lst:bitcoin}

```{.ledger pipe="tee bitcoin.ledger" .numberLines}
2016-12-17 * Coinbase
  Assets:Cash:Banks:Checking    -1000.00 USD
  Expenses:Fees:Banks:Coinbase     15.00 USD
  Assets:Cryptocurrency      1.255000892 BTC @ 784.86 USD

2017-12-17 * Coinbase
  Assets:Cryptocurrency     -1.255000892 BTC {784.86 USD} @ 20089.00 USD
  Expenses:Fees:Banks:Coinbase     10.00 USD
  Income:CapitalGains          -24236.71 USD
  Assets:Cash:Banks:Checking    25211.71 USD

```

Once again, there's a lot going on in @lst:bitcoin, so let's review it in
detail.

Line 4 is using a syntax that effectively says "record this purchase of 1.255…
BTC for 985 USD" by doing the math for you.

Line 7 is where a lot of magic is happening. You're selling the entire 1.255…
BTC holding for 20,089 USD[^ath].
You're specifically calling out the _lot_ [^lots] purchased for 784.86 USD.
You know how much money went into your bank account from the purchase,
25,211.71 USD, and `ledger` actually helps you figure out the capital gains
if you leave the capital gains posting empty. It is filled in in this example
to ensure that the amount is correct.

[^lots]: Lots have an effect on taxation; an explanation of this is outside the scope of
this workshop.

[^ath]: Fun fact: this is the date and amount of Bitcoin's all-time high as of
  the writing of this document.

::: protip

**PROTIP**: Another way to let `ledger` help you figure out complex transactions is to
purposefully omit a posting that you know is necessary. Write the contents of
@lst:bitcoin to a file `bitcoin.ledger`, remove line 9,
and run `ledger -f bitcoin.ledger bal`.
The output should look something like @lst:unbalanced_error.
Then, append `Income:CapitalGains` to that last transaction and run the
`ledger` command again.
Notice how it worked and showed the same amount without having to calculate it
manually or rely on a reported amount from the brokerage.
Note that his method is exactly how this author knew how much to put in
the posting in @lst:bitcoin!

:::

Listing: An example of an unbalanced transaction error {#lst:unbalanced_error}

```
While parsing file "bitcoin.ledger", line 9:
While balancing transaction from streamed input:
Unbalanced remainder is:
        24236.71 USD
Amount to balance against:
        25221.71 USD
Error: Transaction does not balance

```

## Tracking Stock Prices with a Prices Database

`ledger` can use a specially formatted text database containing commodity
pricing information to reflect changes in the value of commodities held.
@lst:stock_purchase reflects the purchase of 87 "COLIN" for $87.00 each.
Run `bal` on this transaction and you'll see a negative balance of $7,569 in
the checking account.

Listing: A basic stock purchase (`stock.ledger`) {#lst:stock_purchase}

```{.ledger pipe="tee stock.ledger"}
commodity USD
  alias $
  format 1,000.00 USD

2020-06-01 * Investment in Colin
  Assets:Investments:Brokerage    87 COLIN @ $87.00
  Assets:Cash:Banks:Checking
```

Let's create a price database in `colin_prices.db`. See @lst:colin_prices for some
content.

Listing: Weekly COLIN prices in June and July 2020 (`colin_prices.db`) {#lst:colin_prices}

```{.ledger pipe="tee colin_prices.db"}
; entry format:
; P <date> [time] <commodity> <amount> <other commodity>
P 2020-06-01 COLIN 87 USD
P 2020-06-08 COLIN 90 USD
P 2020-06-15 COLIN 100 USD
P 2020-06-22 COLIN 97 USD
P 2020-06-29 COLIN 103 USD
P 2020-07-06 COLIN 110 USD
P 2020-07-13 COLIN 90 USD
P 2020-07-20 COLIN 95 USD
P 2020-07-24 COLIN 100 USD
```

Using this prices database, you can view a balance report showing your account
balance taking into account this changing price.
Run `ledger -f stock.ledger --prices-db colin_prices.db --market balance` to
see the current price, shown in @lst:colin_balance.

Listing: Current balances with latest COLIN pricing {#lst:colin_balance}

```{pipe="sh"}
ledger -f stock.ledger --price-db colin_prices.db --market balance
```

### Experimentation

What happens when you add a new entry to the prices database?
What happens to the price if you change the `--end` date?

## A Home as a Commodity {#sec:commodity_home}

A commodity could be a house, condominium, or other ownable real property!
It's all in how you represent it in your transaction log.

Listing: Example transactions for a house (`house.ledger`) {#lst:house_transactions}

```{pipe="ledger -f - print | tee house.ledger"}
commodity USD
  format 1,000.00 USD
  alias $

2014/11/14 House Purchase 123 Main Street
  Assets:Cash:Bank:Checking             -24,000.00 USD
  Expenses:House:ClosingCosts             4,000.00 USD
  Assets:RealEstate:123MainStreet       1 HOUSE @ 100,000.00 USD
  Liabilities:Bank:Mortgage             -80,000.00 USD

2014/12/14 Mortgage Payment
  Assets:Cash:Bank:Checking       -600.00 USD
  Expenses:Interest:Mortgage      150.00 USD
  Liabilities:Bank:Mortgage       450.00 USD

2015/01/14 Mortgage Payment
  Assets:Cash:Bank:Checking       -600.00 USD
  Expenses:Interest:Mortgage      149.00 USD
  Liabilities:Bank:Mortgage       451.00 USD

```

With your mortgage payments tracked like this, your house is in your Assets
and your mortgage is in Liabilities. Therefore, you're tracking them in your net worth,
as recommended in @sec:net_worth.
You can easily check your mortgage interest paid to verify your records against
the IRS Form 1098-INT that your bank issues yearly to support mortgage interest
deductions in the United States.

::: tryit

**TRY IT:** Write a balance query against the records in @lst:house_transactions
that show

1. Mortgage interest paid in 2014
2. Mortgage interest paid since the start of the loan
3. The equity [^equity] in the house as of the latest transaction

:::

[^equity]: Equity is the value of the property minus the mortgage, divided by the value of the property.]

You can track the value of your home in a prices database, too, and account for
estimated fluctuations in its value or track appraisal prices as a base when
refinancing or getting a home equity loan.

