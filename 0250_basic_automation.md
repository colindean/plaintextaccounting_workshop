# Quick and Easy Report Automation {#sec:automation}

It's pretty clear from the previous few chapters that constantly typing out
each `ledger` command would become laborious quickly.
If you're working through this document, you are probably comfortable
or will soon find yourself comfortable with some light programming, so you
might be tempted to _script_ these executions in something like
@lst:simple_script.

Listing: A simple `ledger` script (`simple_script.sh`) {#lst:simple_script}

```{.bash pipe="tee simple_script.sh" .numberLines}
#!/usr/bin/env bash
TX_RECORD="${1}"                  # pass the transaction record in as the first arg
LEDGER_BIN="$(command -v ledger)" # find the ledger command

# Guard against a missing ledger binary
if [[ -z "${LEDGER_BIN}" ]]; then
  echo "ledger isn't found in your PATH, please install it."
  exit 1
fi

# Assemble a convenient way to constantly invoke the program
FILE_ARG="-f ${TX_RECORD}"
LEDGER="${LEDGER_BIN} ${FILE_ARG}"

echo "Net worth:"
${LEDGER} balance ^Assets ^Liabilities

YEAR="${2:-$(date +%Y)}"
echo "Cashflow for ${YEAR}:"
${LEDGER} --begin "${YEAR}" --end "$(( ++YEAR ))" balance ^Income ^Expenses
```

As @lst:simple_script_exec shows, this is a pretty cool first attempt.

Listing: The simple script from @lst:simple_script, invoked with `bash simple_script.sh ex.ledger 2017` {#lst:simple_script_exec}

```{pipe="sh"}
bash simple_script.sh ex.ledger 2017
```

@Lst:simple_script has a simple way to ensure that the `ledger` command
exists on lines 2-9.
It takes the transaction record as the first parameter on line 1.
It builds a convenience variable on lines 12-13 to make executing `ledger` easier.
It executes ledger to produce a net worth report (@sec:networth) on line 16.
It takes an optional second parameter on line 18 for the year to use in the
cash flow report (@sec:cashflow) it executes on line 20.

This is a good start and a rational way to automate reporting.
However, you can quickly take this to the next logical step by shifting your
thinking from producing output in the console or a text file to treating
`ledger` as a type of compiler or conversion tool that produces objects:
reports.

## Thinking in Reports

When using `ledger` and other plain text accounting tools, think in reports:
the results of a query of data presented in a particular format.
Each report has meaning and reusability.
So far, you've read about four different kinds of reports that are the most common for basic personal finance:

1. A generalized or account-scoped balance report
2. A generalized or account-scoped register report
3. A paired short-term balance report: cash flow (@sec:cashflow)
4. A paired long-term balance report: net worth (@sec:networth)

Each of these is comprised of a single query and a single output.
If we put the output of each of these queries into a file, we
can use and reuse these files to create a really cool unified report
comprised of these and other reports.

