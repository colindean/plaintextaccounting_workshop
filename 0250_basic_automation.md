# Quick and Easy Report Automation

## Thinking in Reports

## A Brief Introduction to `make`

## Setting Up a `Makefile` for use with `ledger`

## Solidifying Report Generation

## Querying tagged transactions {#sec:querying_tagged_transactions}

Tagged transactions are a powerful way to set simple key-value pairs of
metadata associated with a transaction. For example, you could track the
contact information of payees or maybe a warranty expiration date for something
you purchased.

Listing: A transaction with a tag comment

```ledger
2020-06-29 Costco
  ; warranty_expiration: 2023-06-29
  Expenses:Electronics:Computer   1,200.00 USD
  Liabilities:CreditCard
````
