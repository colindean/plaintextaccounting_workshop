# Workshop Notes

# Dependencies

Here is a Brewfile for use with [Homebrew](https://brew.sh):

```ruby
# Brewfile for macOS and Linux
brew 'ledger'
brew 'entr'
brew 'ledger-autosync'

```
And some Python packages to install:

```
ledger-autosync
```

## `ledger-autosync` patterns

### Updating a transaction record with new data

`ledger-autosync` uses a _transaction id_ to uniquely identify transactions. When importing from QFX files, this transaction ID is provided by the exporting bank and _should_ always be trustworthy. When importing from CSV files, this transaction ID must be derived. It's generally simply a hash of all of the data in the row concatentated together, e.g.

```python
from functools import reduce
import hashlib

smushed_row = reduce(lambda a,b: a + b, row).encode('utf-8')
csv_id = hashlib.sha256(smushed_row).hexdigest()
```

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

## The tedium: categorizing transactions using accounts in your account tree

Now that you've got some data, you're onto the tedious task of categorizing transactions by replacing the `Equity:Unknown` account with something meaningful.

Don't worry too much about formatting. We'll use `ledger` itself to reformat and sort the transactions you're modifying.

It might be helpful to have a little program showing you what transactions remain to be categorized. [`entr`](http://eradman.com/entrproject/) is a great little tool for watching files for changes and running a command when they change:

```shell
echo 2020.ledger | entr -a -c -p -r ledger -w -f /_ reg Equity:Unknown
```
