## Timelog Account Tree Reference

Here are some ideas for how to structure your account tree for timekeeping with
`ledger` timelog directives as described in @sec:timekeeping.

```{pipe="column -c 80 -t -s '++'"}
N++# Non-billable tasks
N:Email++# Checking email or reading articles as a result of email
N:Meeting++# Any activity done with someone else
N:Meeting:Development++# Any development-related meeting
N:Meeting:Development:Standup++# Regular standup meeting
N:Meeting:Development:Pairing++# Pair programming!
N:Meeting:Development:Support++# Talking with a customer
N:Meeting:HR:OneOnOne++# 1:1 meeting with your management chain
N:Development++# Individual development-related tasks
N:Development:Coding++# Writing code!
N:Development:CodeReview++# Reviewing pull requests
N:Development:Presentation++# Building a presentation
N:Training++# Learning tasks
N:Training:Podcasts++# Listening to podcasts
N:Training:Presentation++# Attending a presentation
B++# Mirror of N hierarchy but used for billing clients
A++# Time away from work
A:Holiday++# Company holidays
A:Vacation++# Time spent not caring about work
A:Sick++# Sick days
A:Errand++# Errands during work time but not enough to take PTO

```
