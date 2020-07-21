## Helpful Accompanying Artifacts & Colophon {#sec:artifacts}

This document was built with [pandoc](https://pandoc.org) and a host of plugins
and other great software.

One particularly great plugin, `panpipe` enabled the listings to contain
program output generated dynamically as the document was built. @Lst:artifacts
contains a list of files available in a companion archive and a SHA256 hash of
that archive as it was packaged at build time to verify its authenticity.

<!-- packaging up the panpipe tmpdir -->

Listing: Artifacts built in the process of compiling this document {#lst:artifacts}

```{pipe="sh"}
ARCHIVE=root/pta_workshop_artifacts.tar.gz
tar -czvf "${ARCHIVE}" --exclude='root' . 2>&1 | sed -e 's%a \.\/%%g' | grep -v 'a\ \.' | sort | paste - - - | column -t
sha256sum "${ARCHIVE}"

```
