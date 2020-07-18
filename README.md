# Plain Text Accounting Workshop

:warning: **This is under active and heavy development.** :warning:

The Markdown files in this directory are [`pandoc`-flavored
Markdown](https://pandoc.org) so they may not correctly render on GitHub. This
is especially true of the tables.

## Contributing

Some `pandoc` filters easily available are required:

```
brew install pandoc-crossref pandoc-include-code pandoc aha make
```

and not so easily available:

* [`panpipe`](https://hackage.haskell.org/package/panpipe "warning: takes forever to compile all dependencies and install") ([git](http://chriswarbo.net/git/panpipe/git/index.html))

**TODO:** Make Homebrew formulae for these and submit them upstream.

Run `make open` to compile the PDF and open it in a PDF viewer.

Run `make watch` to start an edit-compile loop.

Leave it better than you found it.

