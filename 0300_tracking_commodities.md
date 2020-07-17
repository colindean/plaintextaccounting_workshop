# Tracking Multiple Currencies, Stocks, and Other Commodities {#sec:commodities}

## What is a Commodity?


## A Home as a Commodity

A commodity could be a house, condominium, or other ownable real property!
It's all in how you represent it in your transaction log.

Listing: Example transactions for a house {#lst:house_transactions}

```{pipe="tee house.ledger | ledger -f - print"}
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
as recommended in @sec:net_worth_intro.
You can easily check your mortgage interest paid to verify your records against
the IRS Form 1098-INT that your bank issues yearly to support mortgage interest
deductions in the United States.

**TRY IT:** Write a balance query against the records in @lst:house_transactions
that show

1. Mortgage interest paid in 2014
2. Mortgage interest paid since the start of the loan
3. The equity [^equity] in the house as of the latest transaction

[^equity]: Equity is the value of the property minus the mortgage, divided by the value of the property.]

You can track the value of your home in a prices database and account for
estimated fluctuations in its value or track appraisal prices as a base when
refinancing or getting a home equity loan.




## Expressing Purchases
