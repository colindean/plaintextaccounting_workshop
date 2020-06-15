# Workshop Notes

## `ledger-autosync`

Run once on your exported CSV to visually check the output:

```shell
ledger-autosync \
  -a "Assets:Cash:Banks:Dollar:Checking" \
  -l 2020.ledger \
  --unknown-account "Equity:Unknown" \
  export_20200615.csv
```

then run it again and _append_ to your existing transaction record using output redirection `>>`:

```shell
ledger-autosync \
  -a "Assets:Cash:Banks:Dollar:Checking" \
  -l 2020.ledger \
  --unknown-account "Equity:Unknown" \
  export_20200615.csv >> 2020.ledger
```
