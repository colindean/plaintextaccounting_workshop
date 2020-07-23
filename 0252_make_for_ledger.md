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

Listing: Some base variables for `Makefile` (`Makefile.01.vars.txt`) {#lst:makefile_variables}

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
LEDGER = $(LEDGER_BIN) --file $(LEDGER_FILE) $(X)

```

The `Makefile` variables created in @lst:makefile_variables are a great
starting point.
You will inenvitably forget the meaning and utility of some of the tasks
you're about to create, so let's use a fantastic way of documenting the
`Makefile`: creating a "doc comment" that a task can parse out of the
file and display. While you're at it, create another task that will help you
open the year's file without having to remember – or think about – what year it is.
The 2020s have been a a long decade for all of us!

Listing: Helpful tasks for your `Makefile` (`Makefile.02.help.txt`) {#lst:makefile_help}

```{.makefile pipe="tee Makefile.02.help.txt" .numberLines}
### Help Tasks

help: ## Prints help for targets with comments
	@grep -E '^[a-zA-Z._-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		sort | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

edit: $(LEDGER_FILE) ## opens the transaction log for the year in your text editor
	$(EDITOR) $(LEDGER_FILE)

### end help tasks

```

Next, you'll add some basic tasks that generate some reports for display in the
terminal.
Terminal-focused reports are great for quick checks or general use.
Some plain text accounting practitioners never really go past this or skip
directly to a graphical tool like you will learn about in @sec:fava.
Add the contents of @lst:makefile_terminal to your `Makefile`.

Listing: Basic business tasks for viewing common reports (`Makefile.03.terminal.txt`) {#lst:makefile_terminal}

```{.makefile pipe="tee Makefile.03.terminal.txt" .numberLines}
### Terminal Viewing Tasks

bal: $(LEDGER_FILE) ## show all balances
	$(LEDGER) balance

networth: $(LEDGER_FILE) ## show short net worth report
	$(LEDGER) --depth=2 balance ^Assets ^Liabilities

networth-all: $(LEDGER_FILE) ## show complete net worth report
	$(LEDGER) balance ^Assets ^Liabilities

cashflow: $(LEDGER_FILE) ## show cashflow report
	$(LEDGER) balance  ^Income ^Expenses

expenses: $(LEDGER_FILE) ## show non-paycheck expenses (no taxes or health insurance)
	$(LEDGER) balance ^Expenses and not ^Expenses:Taxes and not ^Expenses:Insurance

checklist: $(LEDGER_FILE) ## show a list used to check accounts
	$(LEDGER) accounts ^Assets:Cash ^Liabilities

raw: $(LEDGER_FILE) ## run a query with make raw Q="bal" or drops into console mode
	$(LEDGER) $(Q)

cash: $(LEDGER_FILE) ## show only cash assets
	$(LEDGER) balance ^Assets:Cash

investments: $(LEDGER_FILE) ## show only investments
	$(LEDGER) balance ^Assets:Investments

reimbursements: $(LEDGER_FILE) ## show only reimbursements
	$(LEDGER) balance ^Assets:Reimbursements


### end terminal viewing tasks

```

Now that you've got a lot of tasks in your `Makefile`, run `make help` to see
the help text associated with each tasks or
run `make -f Makefile.help` if you're using the supplementary files from @sec:artifacts.
It will look like @lst:makefile_output_help.
Notice that the doc comment, which has two octothorpes [^octothorpe] on the same line
as the task declaration, becomes the help text.

::: protip

**PROTIP:** Like `ledger`, `make` supports using `-f` or `--file` to specify a file to use
instead of its default `Makefile`. It is convention to use `Makefile` and only
use `Makefile.something` when `something` is some kind of rarely used alternate
mode or it's automatically included in `Makefile` as a collection of subtasks.
This workshop provides a series of Makefiles at various stages of completion.

:::

Listing: The output of `make help` so far (`Makefile.help`) {#lst:makefile_output_help}

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

Finally, your `Makefile` should look like @lst:makefile_after_script.
Note that the top-level comments were removed in order to fit the entirety of
the listing on one page. You can leave them in!

Listing: The finalized basic `Makefile` for a `ledger` project (`Makefile.basic`) {#lst:makefile_after_script}

```{.makefile pipe="cat Makefile.*.txt | grep -v '^# ' | tee Makefile.basic" .numberLines}
```

#### Experimentation

Spend some time using the `Makefile` that you've created.
Rename `ex.ledger` to `2020.ledger`.
Try each of the tasks to get a feel for the output of each.
If you need to, add some transactions in order to generate data.

### Report File Generation

Using the terminal to view reports might sit fine with you, but eventually,
inevitably, you will want to produce more than a text experience for yourself.
You may want to share your findings with others who prefer explanations,
graphs, and more.
In this section, you'll learn how to use ledger to produce files that you can
use to build nice-looking reports.

#### Creating Graphs with GNUplot {#sec:gnuplot}

In order to create some graphs from your records, we need some scripts to help
manipulate the data. Write the contents of @lst:last_entry and @lst:plotsh to
the file specified in the listing caption. Read them as you do it so you can
understand what they are doing.
<!-- not rendered -->
```{pipe="sh"}
mkdir scripts
```
Listing: `scripts/last-entry.sh`, which makes `ledger -j` output easier to graph {#lst:last_entry}

```{.bash pipe="tee scripts/last-entry.sh" .numberLines}
#!/bin/sh
# set is a great way to write safer shell scripts
# -e = exit when a command fails; default is continue!
# -o pipefail = use the exit status of the last executed
#                command in a pipe chain
# -u = use of unset variables is an error
set -euo pipefail
# tac reads a file line by line from the end to beginning
tac | \
  # reverse the order of the data in the lines
  awk '{print $2 " " $1}' | \
  # remove duplicates
  uniq -f 1 | \
  # reverse back to normal
  awk '{print $2 " " $1}' | \
  tac

```

Listing: `scripts/plot.sh`, which runs `gnuplot` on the data provided {#lst:plotsh}

```{.bash pipe="tee scripts/plot.sh" .numberLines}
#!/usr/bin/env bash
set -euo pipefail

filename="${1}"

case "${2}" in
  checking ) title="Checking balances" ;;
  networth ) title="Net worth" ;;
  * ) title="${2}"
esac

# gnuplot provides a DSL for graphing
# here, we're saying to output a PNG image of time-series data
# in a given format with a title specified and use columns 1 and 2
# for the data points in X and Y series on the plot
(cat <<EOF) | gnuplot
  set terminal png
  set xdata time
  set decimal locale
  set format y "\$%'g"
  set timefmt "%Y-%m-%d"
  set xtics rotate
  plot "${filename}" using 1:2 with lines title "${title}"
EOF

```

With those two files written, you can add the tasks in @lst:makefile_graphs to your `Makefile`.

Listing: Graph-making tasks for your `Makefile` (`Makefile.05.graphs.txt`) {#lst:makefile_graphs}

```{.makefile pipe="tee Makefile.05.graphs.txt" .numberLines}
# A convenient place to store our built reports, like a build directory
REPORTS_DIR = reports

graphs: $(REPORTS_DIR) $(REPORTS_DIR)/checking.png $(REPORTS_DIR)/networth.png ## produces graphs

$(REPORTS_DIR)/%.png: $(REPORTS_DIR)/%.balances
	sh scripts/plot.sh $< $(*F) > $@

LAST_ENTRY_SCRIPT = scripts/last-entry.sh

$(REPORTS_DIR)/checking.balances: $(LEDGER_FILE)
	$(LEDGER) register --daily --total-data ^Assets:Cash:Bank:Checking | \
		sh $(LAST_ENTRY_SCRIPT) > $@

$(REPORTS_DIR)/networth.balances: $(LEDGER_FILE)
	$(LEDGER) register --daily --total-data ^Assets ^Liabilities | \
		sh $(LAST_ENTRY_SCRIPT) > $@

$(REPORTS_DIR):
	mkdir -p reports
```

There's a lot going on in @lst:makefile_graphs, so let's break it down.

Lines 6-7 are producing PNG images from `.balances` files using
`scripts/plot.sh`. The `$(*F)` is a special variable that captures what the
text represented by `%` is for the particular invocation.

Lines 11-17 are producing the `.balances` files, which are space-separated
pairs of date and amount produced by the `ledger` command on lines 12 and 16.
This `ledger` command is producing a daily register report, but outputting
formatted with the date and the _total_ column – the rightmost column – to
provide a running total over time. `ledger` will output multiples of the same
day when there are entries on the same day, so you must manually deduplicate
entries: only the last entry of the period is the correct one.
If you wanted to see the amount added each day instead of a running total,
you would use `--amount-data` instead.
This might be useful to identify spikes in particular daily expenses instead of
a running total of how much you've spent on that expense.

Listing: The output of `make graphs` against `ex.ledger` renamed `2020.ledger` or using `LEDGER_FILE=ex.ledger` {#lst:makefile_graphs_run}

```{.bash pipe="bash" .numberLines}
cat Makefile.*.txt > Makefile.graphs
make -j 2 -f Makefile.graphs graphs LEDGER_FILE=ex.ledger
mkdir -p root/build/reports
cp reports/checking.png root/build/reports/checking.png
cp reports/networth.png root/build/reports/networth.png
```

The graphs will look something like those in @fig:checking_balances_graph and
@fig:networth_balances_graph.

![Checking balances in `ex.ledger` (`reports/checking.png`)](build/reports/checking.png){#fig:checking_balances_graph height=2in}

![Net worth balances in `ex.ledger` (`reports/networth.png`)](build/reports/networth.png){#fig:networth_balances_graph height=2in}

#### Experimentation

Using the tasks in @lst:makefile_graphs as a guide, create some of your own graphs.

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

::: tryit

**TRY IT:** try running `time make clean graphs` and then try running `time
make -j 4 clean graphs`. Which is faster? Almost assuredly the latter will be
faster, potentially up to twice as fast!

That paralellism is why programmers love having multiple CPU cores available.
The more cores, the more tasks can be run simultaneously.

:::

