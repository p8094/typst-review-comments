# review-comments

Word-style review comments for [Typst](https://typst.app). Comments are
**hidden by default**; switch them on to see the commented text highlighted
and the notes in an extra right-hand margin.

```typ
#import "@preview/review-comments:0.1.0": *

// enabled: true shows the comments, false (default) hides them.
#show: review-comments.with(enabled: true)

This sentence has a
#comment(author: "Pedro Alves", date: "15 Nov 2026")[Please add citations.][claim that needs support]
and this one an anchor-only note.#comment[Check this number.]
```

- `#comment[note][text]` highlights `text` and attaches `note`.
- `#comment[note]` adds a numbered marker only.
- `author` and `date` are optional.

## Setup options

`review-comments` is applied with `#show: review-comments.with(...)`:

| Option         | Default  | Description                                              |
| -------------- | -------- | -------------------------------------------------------- |
| `enabled`      | `false`  | Show the comments                                        |
| `paper-width`  | `21cm`   | Page width without the comment margin (A4)               |
| `margin-right` | `3cm`    | The document's normal right margin                       |
| `margin-width` | `5.5cm`  | Width of the extra comment margin                        |
| `fill`         | yellow   | Highlight and card colour                                |
| `accent`       | amber    | Colour of the card's left border                         |

When enabled, the page is widened on the right only, so the text layout and
page breaks are identical to the version without comments. Set `paper-width`
and `margin-right` to match your page setup if it is not A4 with a 3cm right
margin. Apply `review-comments` before your own `set page` rules, or make
sure they do not override the right margin.

Notes that would overlap are stacked below one another; with very many
comments on one page the stack may run past the bottom of the page.

## License

MIT
