## Installing ledger2beancount {#sec:install_ledger2beancount}

[`ledger2beancount`](https://github.com/beancount/ledger2beancount) is the most robust way to convert and handle all of the magic that Ledger can do, but in the Beancount world. This installation procedure is a bit hefty for macOS users just to get one little Perl script, but this app is all but required to convert Ledger records to Beancount records in order to use `fava`.  

### Debian or Ubuntu Linux

If you're on Debian or Ubuntu, you can run `apt install ledger2beancount` to install it. 

### macOS

If you're on macOS, we'll have to install from source.

First, we'll install `cpanm` so we can install `ledger2beancount` dependencies and then install the program itself

```shell
brew install cpanminus    
curl -O ledger2beancount.zip https://github.com/beancount/ledger2beancount/archive/master.zip
unzip ledger2beancount.zip
cd ledger2beancount-master
cpanm --installdeps .
```

That last step will take a while. It took about five minutes on my 2015 Macbook Pro.

### Others

Read over the [installation instructions](https://github.com/beancount/ledger2beancount/blob/master/docs/installation.md) if you're not on Debian or Ubuntu or macOS.