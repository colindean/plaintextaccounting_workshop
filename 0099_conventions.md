## Conventions used in this document

This document follows some conventions for convey information.
You've probably already noticed the numbered section headers.
Many clickable elements are highlighted in a different color.
**External links** are blue.
Most links in the prose are noted by red footnote links.
The actual link is at the bottom of the page in the footnotes.
**Internal links** are red and lead to the relevant section, table, figure, or listing.
For example, this is a link to the listing below: @lst:conventions.
If you link on it, the listing will scroll to the top of your view, or whatever
your document reader is configured to do if not that.

`Monospace` text indicates a **command** or a **file name**.
If it follows an imperative verb such as "run" or "execute," then it is
a command that you should execute.
For example, run `date` to see the current date in your terminal.

Some call-out sections will look like this or begin with certain words:

::: tryit

**TRY IT:** This paragraph contains something that you could do for
experimentation. It'll probably be open-ended.

:::

::: protip

**PROTIP:** This paragraph contains something that this author has learned
through experience that will make your life easier knowing ahead of time.

:::

**Listings** contain code snippets or the expected output of a command.
This document is automatically laid out, so some listings will be follow the
relevant text significantly, sometimes several pages later.
This may be confusing at first, but using the internal links will expedite
navigation.
It may be useful to have two side-by-side copies of the document open: one for
reading the prose and one for copying text from the referenced listing.

There are three ways to use the examples provided in listings:

1. You should have received along with this PDF a compressed archive containing
   some supplementary files.
   See @sec:artifacts for what files are in it and how to verify that you have
   the correct archive file for this version of the workshop.
   Unpack that archive.
   Each listing connected to a file in that archive contains a filename in
   parentheses at the end of the caption.
   You can use the content of this file as if you'd copied the file by hand out
   of the workshop text!
1. Some listings can be copied out of the PDF by highlighting them, copying the
   text to your clipboard, and pasting into a text editor. Some document readers
   may capture the line numbers in the process. You can either highlight
   line-by-line or refer to the companion files for this workshop to find the
   text. Apple Preview seems to work as expected while Google Drive PDF Viewer
   copies the line numbers all the time – don't use it!
1. You could type each example by hand directly out of the PDF. This is a bit
   laborious but it can help you learn along the way by doing, approximately
   the same value as copying notes from a teacher's chalkboard.

Listing: An example listing (`example_listing.sh`) {#lst:conventions}

```{.bash pipe="tee example_listing.sh"}
#!/usr/bin/env bash
# run me with:
#    bash example_listing.sh
echo "It contains some shell script."
for i in `seq 1 4`; do
  echo "This is line $i."
done
echo "You can find this file at example_listing.sh,"
echo "you can copy and paste this into a file,"
echo "or you can retype it by hand…"
```

<!-- just to make sure the above works -->
```{pipe="bash example_listing.sh > /dev/null"}
```
