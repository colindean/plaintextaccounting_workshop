## Helpful Accompanying Artifacts & Colophon {#sec:artifacts}

This document was built with [pandoc](https://pandoc.org) and a host of plugins
and other great software.

One particularly great plugin, `panpipe` enabled the listings to contain
program output generated dynamically as the document was built. @Lst:artifacts
contains a list of files available in a companion archive and a SHA256 hash of
that archive as it was packaged at build time to verify its authenticity.

Notably, `Makefile.final` is the assembled version of all `ledger` Makefile
examples in this workshop. You can use it wholesale for your next `ledger`
project: your personal finances!

<!-- packaging up the panpipe tmpdir -->

Listing: Artifacts built in the process of compiling this document {#lst:artifacts}

```{pipe="sh"}
cat Makefile.*.txt | grep -v '^# ' > Makefile.final
ARCHIVE=root/pta_workshop_artifacts.tar.gz
tar -czvf "${ARCHIVE}" --exclude='root' . 2>&1 | sed -e 's%a \.\/%%g' | grep -v 'a\ \.' | sort | paste - - - | column -t
sha256sum "${ARCHIVE}"

```

Run `sha256sum pta_workshop_artifacts.tar.gz` to see the SHA256 hash of the artifacts archive.
If the output matches the long string of letters and numbers on the last line
in @lst:artifacts, you've got the correct companion archive for this version of
the workshop.
If it doesn't match, you can probably still use it, but there might be some
small differences because of changed files. It wouldn't be a bad idea to double
check the listings if the output isn't what you'd expect.

Good luck!
