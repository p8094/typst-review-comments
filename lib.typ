/*
 * review-comments
 *
 * Word-style review comments. `#comment[note][text]` attaches a note to a
 * passage. Comments are invisible by default; with
 * `#show: review-comments.with(enabled: true)` the passage is highlighted and
 * the note appears in an extra right-hand margin (the page is widened on the
 * right only, so text layout and page breaks stay the same).
 */

#let _enabled = state("review-comments-enabled", false)
#let _text-right = state("review-comments-text-right", 0cm)
#let _last = state("review-comments-last", (page: 0, bottom: 0pt))
#let _counter = counter("review-comment")

/// Document-level setup. Apply with `#show: review-comments.with(...)`.
///
/// - enabled (bool): show the comments (default `false`: they are hidden).
/// - paper-width (length): width of the page *without* the comment margin
///   (default: A4, 21cm).
/// - margin-right (length): the document's normal right page margin
///   (default: 3cm).
/// - margin-width (length): width of the extra comment margin.
/// - fill, accent (color): highlight/card colour and the card's left border.
#let review-comments(
  enabled: false,
  paper-width: 21cm,
  margin-right: 3cm,
  margin-width: 5.5cm,
  fill: rgb("#fff2a8"),
  accent: rgb("#e0b800"),
  body,
) = {
  _enabled.update(enabled)
  _text-right.update(paper-width - margin-right)
  state("review-comments-style").update((margin-width: margin-width, fill: fill, accent: accent))
  set page(width: paper-width + margin-width, margin: (right: margin-right + margin-width)) if enabled
  body
}

/// A review comment.
///
/// - ..args: `[note]` or `[note][highlighted text]`.
/// - author (str, content, none): shown in bold on the card.
/// - date (str, content, none): shown next to the author.
#let comment(..args, author: none, date: none) = {
  let pos = args.pos()
  assert(pos.len() in (1, 2), message: "usage: #comment[note][text], or #comment[note] for an anchor-only comment")
  let note = pos.at(0)
  let body = if pos.len() == 2 { pos.at(1) } else { none }
  context if _enabled.get() {
    let style = state("review-comments-style").get()
    let gap = 0.4cm
    let width = style.margin-width - gap - 0.3cm
    _counter.step()
    let n = context _counter.display()
    if body != none { highlight(fill: style.fill, body) }
    super(text(fill: rgb("#b8860b"), weight: "bold", size: 0.8em, n))
    let card = block(
      width: width,
      fill: style.fill.lighten(40%),
      stroke: (left: 1.5pt + style.accent),
      inset: (x: 5pt, y: 4pt),
      radius: 1pt,
      {
        set text(size: 7pt, weight: "regular", style: "normal")
        set par(justify: false, first-line-indent: 0em, leading: 0.4em)
        if author != none or date != none {
          text(weight: "bold")[#n. #author]
          if date != none { h(0.4em); text(fill: luma(100), date) }
          linebreak()
        } else {
          text(weight: "bold")[#n.]
          h(0.3em)
        }
        note
      },
    )
    // Next to its anchor; a note that would overlap the previous one on the
    // same page is pushed down below it.
    box(width: 0pt, context {
      let pos = here().position()
      let last = _last.get()
      let dy = if last.page == pos.page { calc.max(0pt, last.bottom - pos.y + 3pt) } else { 0pt }
      _last.update((page: pos.page, bottom: pos.y + dy + measure(card).height))
      place(top + left, dx: _text-right.get() - pos.x + gap, dy: dy, card)
    })
  } else {
    body
  }
}
