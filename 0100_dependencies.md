# Install Dependencies

Let's install some software that you'll need in order to work through this workshop. It's easiest to install the basics upfront so that you can continue the workshop even if you may be offline later.

There are many dependencies across a few language ecosystems: C++, C, Rust, Python, Perl, and more. A strength of the Plaintext Accounting ecosystem is how easy it is to create tooling for it. While writing a parser takes some time, _producing_ Ledger-format transaction logs is an easy task for even new programers: it's a matter of outputting some text with appropriate whitespace between elements.

Table: Great tools for exploring the Plain Text Accounting ecosystem {#tbl:tool-list}

-----------------------------------------------------------------------------------------------------
Software           Utility                              Website
------------------ ------------------------------------ ---------------------------------------------
`ledger`           The original plain text              https://ledger-cli.org
                   accounting program

`entr`             Runs a command when any in           https://eradman.com/entrproject/
                   a set of files change

`xsv`              CSV querying and manipulation tool   https://github.com/BurntSushi/xsv

`ledger-autosync`  Converts CSV and QFX/OFX             https://github.com/egh/ledger-autosync
                   to Ledger format

`fava`             Web-based transaction exploration    https://beancount.github.io/fava/
                   tool for Beancount ledgers

`ledger2beancount` Converts Ledger-format transaction   https://github.com/beancount/ledger2beancount
                   records to Beancount format
-----------------------------------------------------------------------------------------------------

## Install with a package manager

While you could install each of these programs in @tbl:tool-list separately, it's easiest to do that in a package manager. [Homebrew](https://brew.sh) is the package manager used in examples in this section and the remainder of the workshop. Other package managers described in @tbl:os-pkgman may contain the software necessary to complete this workshop.

Table: Operating system package manager support {#tbl:os-pkgman}

|Operating System|Supported for Workshop?[^os-support-notice]|Recommendation|
|------|--------|----|
|macOS|Yes|Homebrew|
|Linux|Partially|Homebrew or your distro's package manager|
| ChromeOS | Partially | Use [Linux (Beta) mode](https://support.google.com/chromebook/answer/9145439) to install Linux packages and then use [Homebrew](https://brew.sh)  or [Chromebrew](https://skycocker.github.io/chromebrew/) to access other packages. |
|Windows | Partially | Install [WSL](https://docs.microsoft.com/en-us/windows/wsl/install-win10) or use a Linux VM, then follow Linux instructions |
| Android | No | [Termux](https://termux.com/) |
|iOS | No | Please use a desktop operating system for this workshop. |
| Others| No | You probably know what you're doing

[^os-support-notice]: Operating systems that partially-supported are supported when using Homebrew.

Not all dependencies may be available through each package manager, and dependencies with more extensive installation instructions may be detailed at the time of their use.

### Homebrew

If you've not already installed Homebrew, follow the instructions at <https://brew.sh> to install it.

@Lst:brewfile contains `Brewfile` for use with Homebrew. Write its contents to a file called `Brewfile` and then run `brew bundle` to install the software.

```{#lst:brewfile .ruby caption="Brewfile"}
# Brewfile for macOS and Linux
brew 'ledger'
brew 'entr'
brew 'xsv'
brew 'python'
```

### Python's `pip`

After you've installed those packages, you'll need to install some Python packages with [`pip`](https://pypi.org/project/pip/), the package installer for the Python Package Index. Write the contents of @lst:requirements-txt to a file named `requirements.txt` and follow the instruction in the comments to execute the installation process.

```{#lst:requirements-txt caption="requirements.txt"}
# put this into requirements.txt then run
#     pip install -r requirements.txt -U
#
ledger-autosync
fava
```

### Other dependencies to be manually installed

Most of the dependencies listed here are optional. They are required only for one activity and _may_ be omitted or installed when reaching that relevant module of the workshop.

Table: Manually installed dependencies #{tbl:manually-installed}

| Dependency         | Required for | How to install                    |
|--------------------|--------------|---------------------|
| `ledger2beancount` | @Sec:use_ledger2beancount | @Sec:install_ledger2beancount |

## Versions

Aspects of this workshop description are built against certain versions of the dependencies.
The listings below reflect the versions of the software used. Most of the dependencies should
work at any version available as of the date of this workshop on the title page, though.

Listing: Versions of software used in this workshop {#lst:versions}

```pipe
echo "# ledger"
ledger --version | head -n 1
echo "# entr"
entr 2>&1 | head -n 1
echo "# xsv"
xsv --version
echo "# python"
python --version
```

