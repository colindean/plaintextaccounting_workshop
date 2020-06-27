# Install Dependencies

Let's install some software that you'll need in order to work through this workshop. It's easiest to install the basics upfront so that you can continue the workshop even if you may be offline later.

There are many dependencies across a few language ecosystems: C++, C, Rust, Python, Perl, and more. A strength of the Plaintext Accounting ecosystem is how easy it is to create tooling for it. While writing a parser takes some time, _producing_ Ledger-format transaction logs is an easy task for even new programers: it's a matter of outputting some text with appropriate whitespace between elements.

| Software           | Utility                                                        | Website                                       |
|--------------------|----------------------------------------------------------------|-----------------------------------------------|
| `ledger`           | The original plaintext accounting program                      | https://ledger-cli.org                        |
| `entr`             | Runs a command when any in a set of files change               | http://eradman.com/entrproject/               |
| `xsv`              | CSV querying and manipulation tool                             | https://github.com/BurntSushi/xsv             |
| `ledger-autosync`  | Converts CSV and QFX/OFX to Ledger format                      | https://github.com/egh/ledger-autosync        |
| `fava`             | Web-based transaction exploration tool for Beancount ledgers   | https://beancount.github.io/fava/             |
| `ledger2beancount` | Converts Ledger-format transaction records to Beancount format | https://github.com/beancount/ledger2beancount |

## Install with a package manager

While you could install each of these programs separately, it's easiest to do that in a package manager, such as one of the following:

|Operating System|Supported for Workshop?[^os-support-notice]|Recommendation|
|-----|--------|----|
|macOS|Yes|[Homebrew](https://brew.sh)|
|Linux|Partially|[Homebrew](https://brew.sh) or your distro's package manager|
| ChromeOS | Partially | Use [Linux (Beta) mode](https://support.google.com/chromebook/answer/9145439) to install Linux packages and then use [Homebrew](https://brew.sh)  or [Chromebrew](https://skycocker.github.io/chromebrew/) to access other packages. |
|Windows | Partially | Install [WSL](https://docs.microsoft.com/en-us/windows/wsl/install-win10) or use a Linux VM, then follow Linux instructions |
| Android | No | Please use a desktop operating system for this workshop. |
|iOS | No | Please use a desktop operating system for this workshop. |
| Others| No | You probably know what you're doing

[^os-support-notice]: Operating systems that partially-supported are supported when using Homebrew.

Not all dependencies may be available through each package manager, and dependencies with more extensive installation instructions may be detailed at the time of their use.

### Homebrew

Here is a Brewfile for use with [Homebrew](https://brew.sh):

```ruby
# Brewfile for macOS and Linux
brew 'ledger'
brew 'entr'
brew 'xsv'
brew 'python'
```

### Python's `pip`

After you've installed those packages, you'll need to install some Python packages with `pip`:

```
# put this into requirements.txt then run
#     pip install -r requirements.txt -U
#
ledger-autosync
fava
```

### Other dependencies to be manually installed

| Dependency         | How to install                    |
|--------------------|-----------------------------------|
| `ledger2beancount` | See @Sec:install_ledger2beancount |
