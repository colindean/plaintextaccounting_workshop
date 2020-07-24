## Example Financial Accounts Reference

Here are some ideas for how to structure your account tree for tracking your
finances with `ledger`.

One of the hardest parts of getting started with
accounting is knowing or figuring out how to categorize a posting in
a transaction.

This is an extraction from this author's personal transaction logs.

```{pipe="column -c 80 -t -s '++'"}
Assets:Cash:Banks:<Bank>:Checking
Assets:Cash:Banks:<Bank>:Savings
Assets:Cash:Banks:<Bank2>:BackupSavings
Assets:Cash:Banks:<Bank2>:Checking
Assets:Cash:Online:PayPal
Assets:Cash:Online:Venmo
Assets:Cash:Wallet
Assets:Cryptocurrency:Coinbase++# Great for multi-currency
Assets:Cryptocurrency:Personal
Assets:Investments:<OldEmployerStock>
Assets:Investments:HealthSavings
Assets:Investments:<Company>401k
Assets:Investments:Vanguard:Brokerage
Assets:Investments:Vanguard:RolloverIRA
Assets:Investments:Vanguard:RothIRA
Assets:Property:House:<Street>
Assets:Property:<Vehicle>
Assets:Reimbursements:CodeAndSupply
Assets:Reimbursements:<Company>++# Churn on business trips
Equity:Cashback:<Issuer>++# Track that 1% cashback
Equity:Cashback:Costco++# Track that yearly Costco Exec check
Equity:OpeningBalances
Equity:TaxRefund:Federal
Equity:Unknown++# The default for all incoming, uncategorized transactions
Expenses:Alcohol
Expenses:Clothing:General
Expenses:Clothing:Shoes++# Use choice categories to focus on spending reduction
Expenses:Coffee
Expenses:Conference:<Conference>:Registration
Expenses:Conference:Gas
Expenses:Conference:Meals
Expenses:Cycling
Expenses:Dogs:Toys
Expenses:Dogs:Food
Expenses:Dogs:Medical:Checkup
Expenses:Dogs:Medical:Medicine
Expenses:Dogs:Medical:Seresto++# Flea and tick stuff = $$$
Expenses:Donations:Charitable:AlmaMater++# Support the next generation!
Expenses:Donations:Charitable:BikePGH++# Support transit!
Expenses:Donations:Charitable:CodeAndSupplyFund++# Support conferences!
Expenses:Donations:Charitable:DiseaseFoundation++# Support the search for a cure!
Expenses:Donations:Charitable:ElectronicFrontierFoundation++# Support digital rights!
Expenses:Donations:Charitable:FreeSoftwareFoundation++# Support open source!
Expenses:Donations:Charitable:FreeBSD++# Support open source!
Expenses:Donations:Charitable:HackPGH++# Make stuff
Expenses:Donations:Charitable:Kiva++# Pay it forward
Expenses:Donations:Charitable:MetaMeshWirelessCommunities++# Internet the Earth
Expenses:Donations:Charitable:NPONewsOrg++# Support journalism!
Expenses:Donations:Noncharitable++# GoFundMe, etc.
Expenses:Donations:Political:<Candidate>
Expenses:Donations:Political:<501c4Org>
Expenses:Electronics:Batteries++# A small fortune
Expenses:Electronics:Computers:Laptop
Expenses:Electronics:Computers:NAS
Expenses:Electronics:Computers:Parts
Expenses:Electronics:Computers:Repairs
Expenses:Electronics:Headphones++# 2019 was a bad luck year for quality assurance
Expenses:Electronics:Networking++# Homelab addiction
Expenses:Entertainment:GoogleMusic
Expenses:Entertainment:Movies++# Support your small local theater!
Expenses:Entertainment:Museum++# Art and History Appreciation 101
Expenses:Entertainment:Netflix++# Stay home and vege!
Expenses:Entertainment:Performances++# Fine Arts
Expenses:Entertainment:Records++# Vinyl addiction
Expenses:Entertainment:SatelliteRadio++# Never pay full price
Expenses:Entertainment:Shows
Expenses:Entertainment:Waterpark
Expenses:Fees:Annual:<Issuer>:<Type>++# Track CC annual fees
Expenses:Gifts
Expenses:Groceries
Expenses:Haircut
Expenses:House:Appliances
Expenses:House:Bathroom
Expenses:House:Bedding
Expenses:House:Gardening
Expenses:House:Insurance
Expenses:House:Kitchen
Expenses:House:Maintenance
Expenses:House:PestControl
Expenses:House:Utilities:Electric
Expenses:House:Utilities:Internet
Expenses:House:Utilities:MobilePhone
Expenses:House:Utilities:NaturalGas
Expenses:House:Utilities:Sewage
Expenses:House:Utilities:Water
Expenses:Insurance:ADD
Expenses:Insurance:CriticalIllness
Expenses:Insurance:Dental
Expenses:Insurance:GroupTermLife
Expenses:Insurance:Hospitalization
Expenses:Insurance:Legal
Expenses:Insurance:Medical
Expenses:Interest:Mortgage++# You're a query away from filling a 1040 quickly
Expenses:Medical:Copay
Expenses:Medical:Dentist
Expenses:Medical:Devices
Expenses:Medical:Hospitalization
Expenses:Medical:Medicine
Expenses:Medical:Supplements
Expenses:Memberships:AAA
Expenses:Memberships:AmazonPrime
Expenses:Memberships:Costco
Expenses:Memberships:Gym
Expenses:Misc
Expenses:Parking
Expenses:PayrollDeductions:Unspecified
Expenses:Postage
Expenses:Restaurants
Expenses:Software++# Apps, etc.
Expenses:Stuff++# Can't describe it? Punt!
Expenses:Taxes:Income:Federal:EarnedIncome
Expenses:Taxes:Income:Federal:Med
Expenses:Taxes:Income:Federal:Oasdi
Expenses:Taxes:Income:State
Expenses:Taxes:Income:State:EarnedIncome
Expenses:Taxes:Income:State:Unemployment
Expenses:Taxes:Income:Municipal:EarnedIncome
Expenses:Taxes:RealEstate:County
Expenses:Taxes:RealEstate:SchoolTax
Expenses:Taxes:RealEstate:Municipal
Expenses:Taxes:State:Unemployment
Expenses:Taxes:TaxPreparation++# Tax-deductible
Expenses:Travel:Rideshare
Expenses:Travel:Tolls
Expenses:Unknown++# No idea what something is? Punt!
Expenses:Vehicles:<Vehicle>:Gas
Expenses:Vehicles:<Vehicle>:Maintenance
Expenses:Vehicles:<Vehicle>:Registration
Expenses:Vehicles:<Vehicle>:Repairs
Expenses:Vehicles:<Vehicle>:Tires
Expenses:Webhosting:DNS++# It's not DNS / It cannot be DNS / It was DNS
Expenses:Webhosting:Domains++# How much are you spending on domains?
Expenses:Webhosting:Email++# Free email isn't for everyone
Income:AmazonAffiliates++# Track your affiliate programs
Income:Interest:<Bank>++# Capture interest, makes taxes easier
Income:<Company>:401kMatch++# Match paid until you track the investment
Income:<Company>:Bonus:Performance
Income:<Company>:Bonus:Signon
Income:<Company>:GroupTermLife++# Company-paid insurance
Income:<Company>:HealthSavings++# HSA contributions from the company
Income:<Company>:Salary++# General income
Income:Unemployment++# Taxable
Liabilities:CreditCard:<Issuer>:<Type>++# Issuer/Type pair for each card
Liabilities:Loans:Auto:<Make>:<Model>++# Keep detail for analysis
Liabilities:Mortgage:<Bank>:<Street>++# Track against Assets:Property:House


```
