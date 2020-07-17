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

**Listings** contain code snippets or the expected output of a command.
This document is automatically laid out, so some listings will be follow the
relevant text significantly, sometimes several pages later.
This may be confusing at first, but using the internal links will expedite
navigation.
It may be useful to have two side-by-side copies of the document open: one for
reading the prose and one for copying text from the referenced listing.

Listing: An example listing {#lst:conventions}

```bash
# This is a listing.
echo "It contains some shell script."
for i in `seq 1 4`; do
  echo "This is line $i."
done
echo "Be sure you can copy and paste this into a file."
```
