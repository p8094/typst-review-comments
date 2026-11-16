#import "lib.typ": *

// Set `enabled: true` to show the comments.
#show: review-comments.with(enabled: true)
#set par(justify: true)

= Example

Review comments are hidden by default. This sentence has a
#comment(author: "Pedro Alves", date: "15 Nov 2026")[Please add citations here.][claim that needs support]
and this one has an anchor-only note.#comment[Check this number.]

A third comment is #comment(author: "Pedro Alves", resolved: true)[Citation added, thanks.][already resolved] and shows in green.
Use `show-resolved: false` in the setup to hide resolved comments.
