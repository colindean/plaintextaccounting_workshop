## Setting Up a `Makefile` for use with `ledger` {#sec:make_for_ledger}

In this section, you will read prose and in-line comments to learn about `make`
and `ledger` at the same time, and maybe some other helpful utilities along the
way.

Note that this `Makefile` you are building relies on following a hierarchy of
accounts matching what this author uses for his personal finances. This
`Makefile` is nearly identical to what he uses. It has been modified only
for clarity and actual useful improvements that he should have done long ago!

### Using Make Instead of a Script

Revisit the simple script in @lst:simple_script.
This approach is fine, but for benefits we'll _really_ see in @sec:parallelism,
you must to implement some helpful tasks in in a `Makefile` instead of a
simple shell script.

A convenient way pass commands into `make` when running it is to use
environment variables specified at invocation.
For example,
`make report YEAR=2019` would run the `report` task after setting the `YEAR`
variable during startup. You'll use this mechanism to override some default
values that you'll specify at the top of the `Makefile`.

Listing: Some base variables for `Makefile` {#lst:makefile_variables}

```{.makefile pipe="tee Makefile.01.vars.txt" .numberLines}
# The year for reports tied to a year, defaults to the current year.
# Unlike shell scripting, where this would be $(date) or `date`,
# Makefile provides a special function $(shell cmd) to run a command.
YEAR = $(shell date +%Y)

# The path to the ledger binary. In general, it'll be on your $PATH
# but if you want to use a different ledger binary or perhaps use it
# provided within a Docker container, you'll need a way to override it.
LEDGER_BIN = ledger

# It's a common practice to put all transactions into one file per year
# and use the `equity` command from the previous year to start off the
# new year file
LEDGER_FILE = $(YEAR).ledger

# This combined variable provides a convenient way to execute ledger
# with the file already populated, plus a convenient way to inject
# eXtra arguments into the command as a one-off. This is a great way
# to test new commands.
LEDGER = $(LEDGER_BIN) -f $(LEDGER_FILE) $(X)

```

The `Makefile` variables created in @lst:makefile_variables are a great
starting point.
You will inenvitably forget the meaning and utility of some of the tasks
you're about to create, so let's use a fantastic way of documenting the
`Makefile`: creating a "doc comment" that a task can parse out of the
file and display. While you're at it, create another task that will help you
open the year's file without having to remember – or think about – what year it is.
The 2020s have been a a long decade for all of us!

Listing: Helpful tasks for your `Makefile` {#lst:makefile_help}

```{.makefile pipe="tee Makefile.02.help.txt" .numberLines}
### Help Tasks

help: ## Prints help for targets with comments
	@grep -E '^[a-zA-Z._-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		sort | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

edit: $(LEDGER_FILE) ## opens the transaction log for the year in your text editor
	$(EDITOR) $(LEDGER_FILE)

## end help tasks
```

Next, you'll add some basic tasks that generate some reports for display in the
terminal.
Terminal-focused reports are great for quick checks or general use.
Some plain text accounting practitioners never really go past this or skip
directly to a graphical tool like you will learn about in @sec:fava.
Add the contents of @lst:makefile_terminal to your `Makefile`.

Listing: Basic business tasks for viewing common reports {#lst:makefile_terminal}

```{.makefile pipe="tee Makefile.03.terminal.txt" .numberLines}
### Terminal Viewing Tasks

bal: $(LEDGER_FILE) ## show all balances
	$(LEDGER_CMD) balance

networth: $(LEDGER_FILE) ## show short net worth report
	$(LEDGER_CMD) --depth=2 balance ^Assets ^Liabilities

networth-all: $(LEDGER_FILE) ## show complete net worth report
	$(LEDGER_CMD) balance ^Assets ^Liabilities

cashflow: $(LEDGER_FILE) ## show cashflow report
	$(LEDGER_CMD) balance  ^Income ^Expenses

expenses: $(LEDGER_FILE) ## show non-paycheck expenses (no taxes or health insurance)
	$(LEDGER_CMD) balance ^Expenses and not ^Expenses:Taxes and not ^Expenses:Insurance

checklist: $(LEDGER_FILE) ## show a list used to check accounts
	$(LEDGER_CMD) accounts ^Assets:Cash ^Liabilities

raw: $(LEDGER_FILE) ## run a query with make raw Q="bal" or drops into console mode
	$(LEDGER_CMD) $(Q)

cash: $(LEDGER_FILE) ## show only cash assets
	$(LEDGER_CMD) balance ^Assets:Cash

investments: $(LEDGER_FILE) ## show only investments
	$(LEDGER_CMD) balance ^Assets:Investments

reimbursements: $(LEDGER_FILE) ## show only reimbursements
	$(LEDGER_CMD) balance ^Assets:Reimbursements


## end terminal viewing tasks
```

Now that you've got a lot of tasks in your `Makefile`, run `make help` to see
the help text associated with each tasks.
The doc comment which has two octothorpes [^octothorpe] becomes the help text.

Listing: The output of `make help` so far {#lst:makefile_output_help}

```{pipe="bash" .numberLines}
cat Makefile.*.txt > Makefile.help
make -f Makefile.help help | aha | pandoc -f html -t plain
```

**PROTIP:** Always remember to leave helpful comments in your code: you are helping the
next person to read the code or documentation understand what you meant, and
it's more than likely that the next person will be yourself.

[^octothorpe]: Really, that's its real name, but it's commonly called a
  "hash" or "hashtag" or "pound" or "number". Musicians might call it a "sharp"
  in a musical context. Try injecting _that_ into a technical conversation
  sometime.

Let's examine some of these tasks in @lst:makefile_terminal beyond their help text.

Lines 3-4's task is the basic `balance` report: "show me all balances for all data".
Lines 6-10 provide you with net worth, but a limited view on the `networth` task
because listing all assets might get long if you have a lot of `Assets:Cash`
subaccount accounts (`Assets:Cash:Banks`, perhaps a checking and a savings
account for each bank; `Assets:Cash:Online` for things like PayPal, Venmo,
Square Cash App, and so on.) or a lot of `Assets:Investments` accounts such as
employer 401(k)s, IRAs, and other things that you may not care about at a finer
detail than "all investments" most of the time when looking at your net worth
statement.

Lines 15-16 provide a way to see only expenses and only those that are not
normal paycheck deductions such as income taxes and insurances.
This report is useful to see expenses I actively control, be they automatic
bill payments or normal daily transactions.
It's important to separate these because for those with a savings mentality,
taxes may be a significant portion of yearly expenses.

Lines 18-19 help this author know what accounts need to be checked regularly.
Note the usage of the `accounts` report.
Lines 21-22 provide the ability to run a raw query by simply passing whatever
is in the `Q` environment variable to `ledger`.
For example, `make raw Q="balance ^Assets:Cash"` would execute the same report
as what's on lines 24-25.
The remaining tasks in @lst:makefile_terminal are shortcuts for investments
balances and `Assets:Reimbursements`, a great account to track loans made to
friends or to your employer if you covered an expenses on a personal credit
card instead of a company credit card [^churning].

[^churning]: There's a whole practice to this called "churning" that not only
  involves charging company expenses on a personal card but also finding ways
  to take advantage of rewards programs to earn significant travel perks for
  personal use. If you will ever travel for work, this is a cool thing to look
  into in order to be able to spend some vacation time somewhere you want to
  go.

Finally, your `Makefile` should look like @lst:makefile_final.

Listing: The finalized basic `Makefile` for a `ledger` project {#lst:makefile_final}

```{.makefile pipe="cat Makefile.*.txt | tee Makefile.basic" .numberLines}
```

#### Experimentation

Spend some time using the `Makefile` that you've created.
Rename `ex.ledger` to `2020.ledger`.
Try each of the tasks to get a feel for the output of each.
If you need to, add some transactions in order to generate data.

### Report File Generation

#### Parallelism {#sec:parallelism}

One of the most powerful features of `make` is its ability to build an internal
[directed acyclic graph](https://en.wikipedia.org/wiki/Directed_acyclic_graph)
of tasks to be executed and then execute those tasks in parallel where
possible.
This parallel execution is particularly useful when the production of a single
build artifact – a program – is actually the result of combining several
smaller products.

This sounds familiar, no? It is the same as what you are doing in building
reports with your `ledger` transaction log.
For one business for which this author handles finances, the difference between
running `make statement`, which runs all reports and builds the final document
serially, and `make -j 8 statement`, which runs reports in parallel before
building the final document, is dozens of seconds.
As the transaction log grows over time, the savings will only get bigger!


