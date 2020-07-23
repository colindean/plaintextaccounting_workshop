# Plain Text Accounting Workshop

:warning: **This is under active and heavy development.** :warning:

The Markdown files in this directory are [`pandoc`-flavored
Markdown](https://pandoc.org) so they may not correctly render on GitHub. This
is especially true of the tables.

## Contributing

Run `brew bundle` to install the easily available dependencies to build this
workshop document.

And then there's the no so easily available:

* [`panpipe`](https://hackage.haskell.org/package/panpipe "warning: takes forever to compile all dependencies and install") ([git](http://chriswarbo.net/git/panpipe/git/index.html))

Run `make open` to compile the PDF and open it in a PDF viewer.

Run `make watch` to start an edit-compile loop.

The № 1 rule? _Leave it better than you found it._

## License

This work is licensed under Creative Commons BY-NC-SA 4.0.
You are free to share and adapt this workshop but you must provide attribution
to Colin Dean, you must share your changes under the same license, and you may
not use this workshop for commercial purposes.
See [LICENSE.md](LICENSE.md) for more infromation.
