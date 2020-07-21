# Time Keeping with `ledger` {#sec:timekeeping}

`ledger` has a built-in set of directives that enable tracking time spent doing
activities.
These directives create transactions under the hood in commodities for seconds,
minutes, hours, and so on.
It establishes commodity conversions that allow ledger to report meaningfully
on time spent, regardless of the unit of time.

This author was introduced to `ledger` not through personal finance, but
through a search for a better way to track consulting hours. As such, he's
tracked time for _years_ using `ledger`. This section briefly covers these
practices and links to existing, production-quality tooling enabling time
keeping complete with analysis tools.

@Lst:timekeeping shows a day in the life of `ledger` time keeping through its
timelog mode. Interacting with these time records is easy: you can use
`balance` and `register` just as if these records were normal transactions.
@Lst:timekeeping_bal shows the balance report.

Listing: A simple timekeeping transaction record {#lst:timekeeping}

```{.ledger pipe="tee time.ledger"}
; My convention:
;   N: non-billable time | B: billable time | A: away time; PTO, holidays
i 2020/07/03 09:30:00 N:Email
o 2020/07/03 10:00:00
i 2020/07/03 10:00:00 N:Development:Coding
o 2020/07/03 11:45:00
i 2020/07/03 11:45:00 N:Meeting:Standup
o 2020/07/03 12:00:00
i 2020/07/03 12:00:00 N:Development:Coding
o 2020/07/03 12:45:00
i 2020/07/03 12:45:00 N:Development:CodeReview
o 2020/07/03 13:15:00
i 2020/07/03 13:15:00 N:Development:Coding
o 2020/07/03 16:00:00
i 2020/07/03 16:00:00 N:Meeting:Development:Pairing
o 2020/07/03 17:00:00
i 2020/07/03 17:00:00 N:Training:ConferenceTalks
o 2020/07/03 17:30:00
i 2020/07/04 10:00:00 A:Holiday
o 2020/07/04 18:00:00

```

Listing: A balance report on @lst:timekeeping {#lst:timekeeping_bal}

```{pipe="sh" }
ledger -f time.ledger bal

```

These directives can be kept in your financial records or a separate file.
This author keeps his in a separate file on his employer-owned workstation and
backs them up to a cloud file hosting service.

If you want to give this time tracking system a try, check out the
production-quality scripts noted in @tbl:timekeeping that are well-exercised since
their origin starting around 2013.

::: tryit

**TRY IT**: Think about how you spend your last two days and represent that in
ledger timelog form.

:::

Table: Colin Dean's time keeping scripts {#tbl:timekeeping}

|Script           |Purpose                                                    |
|-----------------|-----------------------------------------------------------|
| [`t`][script_t] | A script that automates the creation of `ledger` timelog entries |
| [`_t_completion`][script_t_completion] | Provides bash shell completions for `t`] |
| [`analyze_t`][script_analyze_t] | Uses `t` and `gnuplot` to produce graphs of weekly hours [^overwork] |
| [`hours.1m.sh`][script_bitbar] | A plugin script for [Bitbar][bitbar] to show current task and daily/weekly hours in the macOS menubar|

Listing: `t` options {#lst:t_options}

```{pipe="sh"}
t help

```

[^overwork]: The graphs are focused on combating overwork by visualizing hours
  worked and showing when and by how much those hours worked exceed 40 hours
  per week.

[script_t]: https://github.com/colindean/hejmo/blob/master/scripts/t
[script_bitbar]: https://github.com/colindean/hejmo/blob/master/dotfiles/bitbar/work/hours.1m.sh
[bitbar]: https://getbitbar.com/
[script_t_completion]: https://github.com/colindean/hejmo/blob/master/scripts/_t_completion
[script_analyze_t]: https://github.com/colindean/hejmo/blob/master/scripts/analyze_t
