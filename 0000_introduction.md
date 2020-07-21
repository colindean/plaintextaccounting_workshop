# Introduction

This workshop aims to teach accounting basics and teach how to use the core tools of the Plain Text Accounting ecosystem in a workflow familiar to software developers who prefer command line tools, build systems, and easily-transported report formats.

## What is Plain Text Accounting?

Plain Text Accounting is the practice of maintaining an accounting ledger in a format that values human readability, accountant auditability, and version control. The ecosystem of PTA tools includes programs categorized as "ledger-like" which enable recording of purchases and transfers and investments, versioning of ledger-files to provide an audit trail, and performing analysis to produce registers, balance sheets, profit and loss statements, track billable time and paid time off, and lots of other reports.

## For whom was this workshop designed?

This workshop is geared toward folks with the following skills:

1. Comfortability with basic algebra
2. Comfortability using a computer with a suitable keyboard or another input method for typing
3. Comfortability using a text editor program, such as Atom, Visual Studio Code, vim, or Emacs
4. Comfortability installing and using command line software on the operating system of their choice

and the following things available to them:

1. A computer running a UNIX-like operating system or having standard UNIX tools available to it. That explicitly includes **Apple macOS** or virtually any modern **Linux** distribution, such as **Ubuntu Linux**. **Microsoft Windows** can be used when using UNIX tools via _Windows Subsystem for Linux_. For more information, see @tbl:os-pkgman.
1. Internet access, to install tools required to follow the workshop activities.

## Why should you care?

Developers throughout the world are often highly-compensated professionals. By carefully capturing and documenting the flow of one's money, these professionals can avoid mismanaging their personal finances and squandering the assets at their disposal, preserving more funds for important things like debt repayment, retirement investment, vacations, and charitable contributions. This talk introduces personal finance accounting in general and moves into teaching how to use the open source plain text accounting ecosystem to manage one's money.

The majority of tools in this ecosystem and free and open-source software, meaning you can rely on them to always be freely available to you for your use, modification, and, in most cases, redistribution. The absence of lock-in means you own your data
without concern for being locked out of your hard work because of a price increase or service outage.

## Workshop goals

In this presentation, you'll learn

* basic generally-accepted accounting principals (GAAP) and double-entry accounting,
* `ledger` command line tool usage,
* alternatives to and similar programs that complement `ledger`
* why you might choose Plain Text Accounting over other tools such as Quicken, QuickBooks, Mint.com, or You Need a Budget
* how to track daily transactions as well as investments, from brokerage accounts to cryptocurrencies
* how to automate some entry of data
* how to build informative reports with HTML, SVG, PDFs, and more
* how to securely backup your financial data stored as plain text

Anti-goals, or things you won't learn or things specifically avoided in this
workshop:

* how to compile from source most of the tools used, since most are available
    in binary form through a package manager. Only those unavailable are
    explained in this workshop.
* how to use _everything_ that `ledger` has to offer, since `ledger` is an
    in-depth program with a variety of modes that not even the author uses
    frequently, and this should not take the place of the
    [`ledger` documentation](https://www.ledger-cli.org/3.0/doc/ledger3.html).

## Workshop agenda

This workshop will take approximately 150 minutes.

Time breakdown:

* 45 minutes: Presentation of GAAP, double-entry accounting basics, `ledger` format basics, and why `ledger`
* 10 minutes: Q&A and break
* 45 minutes: Collecting data, experimenting with `ledger`
* 5 minutes: break
* 45 minutes: Building and automating reports

If any time remains, you can work through an optional module exploring time tracking using `ledger`.

## Things You'll Have When You Are Done

1. A basic understanding of accounting principals
1. The knowledge to read and write `ledger` transaction records to represent
   daily transactions, payments, stocks, and inventory
1. The knowledge to query transaction logs with `ledger`
1. A simple script to run `ledger`
1. A better way than that script to run `ledger`: `make`
1. A `make` configuration that you could use to be immediately productive
   tracking your own finances if you build transaction records from your
   financial statements
1. A way to convert your bank statement exports to `ledger` transaction records
1. A way to track your time using `ledger`

## About the author

Colin Dean has been using Plain Text Accounting tools since the early 2010s for his work time tracking, his personal finances, and managing the finances of the for-profit and non-profit organizations he administers. He runs the [/r/plaintextaccounting subreddit](https://reddit.com/r/plaintextaccounting) and has contributed to the Plain Text Accounting ecosystem through educational presentations, bug reporting, and software development.
