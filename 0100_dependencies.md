# Install Dependencies {#sec:dependencies}

Let's install some software that you'll need in order to work through this workshop. It's easiest to install the basics upfront so that you can continue the workshop even if you may be offline later.

There are many dependencies across a few language ecosystems: C++, C, Rust, Python, Perl, and more. A strength of the Plain Text Accounting ecosystem is how easy it is to create tooling for it. While writing a parser takes some time, _producing_ Ledger-format transaction logs is an easy task for even new programers: it's a matter of outputting some text with appropriate whitespace between elements.

Table: Great tools for exploring the Plain Text Accounting ecosystem {#tbl:tool-list}

-----------------------------------------------------------------------------------------------------
Software           Utility                              Website
------------------ ------------------------------------ ---------------------------------------------
`ledger`           The original plain text              https://ledger-cli.org
                   accounting program

GNU `make`         Task- and file-based build system    https://www.gnu.org/software/make/
                   standard across multiple ecosystems

`gnuplot`          Renders graphs from data files       http://www.gnuplot.info/

`xsv`              CSV querying and manipulation tool   https://github.com/BurntSushi/xsv

`entr`             Runs a command when any in           https://eradman.com/entrproject/
                   a set of files change

`ledger-autosync`  Converts CSV and QFX/OFX             https://github.com/egh/ledger-autosync
                   to Ledger format

`ledger2beancount` Converts Ledger-format transaction   https://github.com/beancount/ledger2beancount
                   records to Beancount format

`fava`             Web-based transaction exploration    https://beancount.github.io/fava/
                   tool for Beancount ledgers

-----------------------------------------------------------------------------------------------------

## A Note before Installing

It may be tempting to install each of these packages one-by-one, or in groups,
but it's a good practice to use per-project package manifests. Those are
provided in @sec:install_homebrew and @sec:install_pip.

The next two sections provide one-liners to install their packages if you don't
want to wait and use the other method or want to install just enough to get
through the basics of the workshop.

## The Basics

In order to complete the most meaningful parts of this workshop, you will need
to install `ledger` for @sec:reports_balance, GNU `make` for @sec:make_intro,
and `gnuplot` for @sec:gnuplot. @lst:install_basics provides a quick one-liner
to install these if you don't want to use a Homebrew manifest in
@sec:install_homebrew.

Listing: Package installer lines for the basics {#lst:install_basics}

```bash
# macOS and Linux with Homebrew
brew install ledger make gnuplot
# Windows with Chocolatey
choco install ledger make gnuplot
# Windows with Scoop, ledger unavailable
scoop install make gnuplot
# Ubuntu/Debian Linux
apt install ledger make gnuplot
# Alpine Linux
apk add ledger make gnuplot
```

## The Advanced Dependencies

In order to complete the entire workshop, you will need to additionally install
`xsv` for @sec:sync_clean,
`python` and some Python packages from the Python Package Index (PyPI) starting
in @sec:autosync_updates,
and
`entr` for @sec:categorizing.

## Installing Everything At Once with a Package Manager

While you could install each of these programs in @tbl:tool-list separately, it's easiest to do that in a package manager. [Homebrew](https://brew.sh) is the package manager used in examples in this section and the remainder of the workshop. Other package managers described in @tbl:os-pkgman may contain the software necessary to complete this workshop.

Table: Operating system package manager support {#tbl:os-pkgman}

|Operating System|Supported for Workshop?[^os-support-notice]|Recommendation                       |
|----------------|---------------|-----------------------------------------------------------------|
|macOS|Yes|Homebrew|
|Linux|Partially|Homebrew or your distro's package manager|
| ChromeOS | Partially | Use [Linux (Beta) mode](https://support.google.com/chromebook/answer/9145439) to install Linux packages and then use [Homebrew](https://brew.sh)  or [Chromebrew](https://skycocker.github.io/chromebrew/) to access other packages. |
|Windows | Partially | Install [WSL](https://docs.microsoft.com/en-us/windows/wsl/install-win10) or use a Linux VM, then follow Linux instructions |
| Android | No | [Termux](https://termux.com/) |
|iOS | No | Please use a desktop operating system for this workshop. |
| Others| No | You probably know what you're doing

[^os-support-notice]: Operating systems that partially-supported are supported when using Homebrew.

Not all dependencies may be available through each package manager, and dependencies with more extensive installation instructions may be detailed at the time of their use.

### Homebrew `Brewfile` for most dependencies {#sec:install_homebrew}

If you've not already installed Homebrew, follow the instructions at <https://brew.sh> to install it.

@Lst:brewfile contains `Brewfile` for use with Homebrew. Write its contents to a file called `Brewfile` or use that file from the supplementary artifacts and then run `brew bundle` to install the software.

```{#lst:brewfile .ruby caption="Brewfile" pipe="tee Brewfile"}
# Brewfile for macOS and Linux
brew 'ledger'
brew 'make'
brew 'gnuplot'
brew 'entr'
brew 'xsv'
brew 'python'
```

### Python dependencies with `pip` {#sec:install_pip}

After you've installed those packages, you'll need to install some Python packages with [`pip`](https://pypi.org/project/pip/), the package installer for the Python Package Index. Write the contents of @lst:requirements-txt to a file named `requirements.txt` or use that file from the supplementary artifacts and follow the instruction in the comments to execute the installation process.

Note that you may already have a Python 2.x environment installed and set to
default even if you install Python 3.x in an earlier step. Be sure that when
you run `pip --version`, you see `python 3.x` like what's in @lst:versions for
`pip`.
If you don't, use `pip3` to install the packages in @lst:requirements-txt.

Listing: `requirements.txt` {#lst:requirements-txt}

```{pipe="tee requirements.txt"}
# put this into requirements.txt then run
#     pip install -r requirements.txt -U
#
ledger-autosync
fava
```

### Other Advanced Dependencies to be Manually Installed

Most of the dependencies listed in @tbl:manually-installed are optional. They are required only for one activity and _may_ be omitted or installed when reaching that relevant module of the workshop.

Table: Manually installed dependencies {#tbl:manually-installed}

| Dependency         | Required for | How to install                    |
|--------------------|--------------|---------------------|
| `ledger2beancount` | @Sec:use_ledger2beancount | @Sec:install_ledger2beancount |

## Versions

Aspects of this workshop description are built against certain versions of the dependencies.
The listings below reflect the versions of the software used. Most of the dependencies should
work at any version available as of the date of this workshop on the title page, though.

Listing: Versions of software used in this workshop {#lst:versions}

```{pipe="sh"}
echo "# ledger"
ledger --version | head -n 1
echo "# entr"
entr 2>&1 | head -n 1
echo "# xsv"
xsv --version
echo "# python"
python --version
echo "# pip"
pip --version
echo "# make"
make -v | head -n 1
echo "# gnuplot"
gnuplot --version
```

