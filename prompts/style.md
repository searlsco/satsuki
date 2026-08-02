# Editorial standard: glosses and usage notes

Shared by every satsuki pipeline stage. `author.md`, `reviewer.md`, and the
re-edit passes all include this file. It governs the two fields a learner
actually reads first.

## Why the constraints are what they are

satsuki's fields are consumed, not just read. In MemoryHole, `glosses` are
joined with `"; "` into a one-line search row, listed as numbered senses in
the pattern view, shown as the hint on a flashcard (first three), and graded
as accepted answers. `usage_note` is rendered as raw text.

Three consequences, all non-negotiable:

- **A gloss must stand alone as an answer.** Someone typing it into a
  flashcard should be marked correct. A gloss that describes the pattern
  ("marks the object of a stative predicate") or that leans on a sibling
  ("by, unlike the rule sense") fails as an answer.
- **The gloss list must read as one line.** Three glosses with long
  parentheticals become an unreadable search row.
- **The note may not contain bracket ruby.** It renders literally:
  `危[あぶ]ない` appears on screen exactly like that. Japanese in a note is
  written bare (`危ない`).

## The lane problem

Tsutsuji files one surface under several semantic classes when it has
several senses. によって is filed three times, をもって three times, で four
times. Each filing is a **lane**, and its class name is the lane's identity.

The failure this standard exists to prevent: an author writes a true
description of the *surface* instead of a description of its *lane*. Every
job によって does is a true fact about によって, and stating all of them under
状況-般 is still wrong, because it hands the learner no way to tell the three
entries apart and makes the search results read as triplicate noise.

**Truth about the language is not truth about the lane.** Write only the
lane, and name the siblings so the learner knows where the rest went.

Published dictionaries handle this the same way. 『どんなときどう使う日本語
表現文型辞典』 splits によって into four entries, each with a short sense tag
(〈原因・理由〉〈手段・方法〉〈受け身の動作主〉〈対応〉), a one-phrase Japanese
paraphrase, and a two-word English gloss. Its front matter states the
convention outright: when a headword recurs, add a tag naming the semantic
difference (うえで〈事後〉 vs うえで〈目的〉), and order entries with the
basic, most general sense first. satsuki has no tag field, so the tag's job
is done by the first gloss and the note's first clause.

## Glosses

One to three, dictionary-sense style, shortest wording that is accurate.

1. **Gloss 1 is the lane's core sense**, in the plainest English available.
   Where the surface is filed under more than one class, gloss 1 alone must
   distinguish this lane from every sibling lane. If two sibling entries
   could carry the same gloss 1, at least one of them is wrong about its
   lane.
2. **A gloss may carry one short parenthetical qualifier**, and only to say
   what *this* lane is: `by (the agent of a passive)`. Never to say what it
   is not, never to reference a sibling, never more than about four words.
   Prefer no qualifier when gloss 1 is already unambiguous: `depending on`
   needs nothing.
3. **Never include a sense belonging to another lane**, however true it is
   of the surface. A gloss list that is a superset of a sibling's list is
   always a defect.
4. **No sentence-long definitions and no metalanguage**, with one
   exception below. Gloss what the learner would write in English.
5. Split senses inside one gloss with `; `. Use the spaced ellipsis style
   `no sooner … than` where a gloss splits around a clause.

**The untranslatable-marker exception.** A few patterns are pure
grammatical markers with no English equivalent: case particles, some
sentence-final particles. DBJG handles these with a short function
description in place of a translation ("a particle which marks a direct
object", six words), and still supplies real glosses whenever any exist
("nothing / nobody / no ~ but; only" for しか). Follow that: when and only
when no English rendering exists, gloss 1 may be a function description of
that length. It must still read as a recognizable label, not a linguistics
sentence, and a description never occupies gloss 2 or 3 — if there is
nothing translatable to say, stop at one gloss rather than padding with a
parenthetical fragment.

## Usage notes

Two to four sentences, at most about 400 characters. The current corpus
medians 486 characters and spends its first sentence, median 179
characters, on register and variant forms before reaching the sense. Invert
that.

**Sentence 1 names the lane, in its first clause, before anything else.**
No etymology, no register, no variant inventory ahead of it. State the job:
what relation this pattern sets up, and what it takes on either side. One
or two bare-kanji Japanese fragments to anchor it are good.

**Sentence 2 is the contrast, and only for a surface filed under more than
one class.** Name each sibling lane by its sense and give it a two-or-three
word Japanese anchor, so a learner who landed on the wrong entry can leave.
Refer to lanes by what they mean, not by class code or `l2_id`.

**Sentence 3, optional: the one fact that changes what a learner writes.**
An attachment restriction, a register limit that would make the sentence
wrong, or a real-usage attachment the corpus rule does not license. One
fact, the most consequential one.

Cut, unless it disambiguates: variant-form inventories (により / による /
によりまして), etymology, politeness ladders, and any sentence that tells the
learner what to think rather than what is true. Delete the editorial voice:
"is at home in", "leans toward", "reaches for", "learners should keep it
apart from". Absolutes ("never", "only", "cannot") still require a source;
where usage merely leans, write "typically" or "usually".

Japanese inside a note is bare, never bracket ruby.

## Sense rank

Every pattern carries a `sense_rank`. Where a surface has more than one
lane, the lanes are ranked `1..n`, contiguous and unique within the family:
`1` for the sense a learner meets first and most often. A surface with no
sibling lane is simply its own rank `1`, so the field is never absent.

This exists because consumers that merge same-surface patterns into one
entry lead their listings with rank 1 and gate the later senses behind it.
Rank by how common and general the sense is in contemporary Japanese, not
by how interesting it is. Tsutsuji difficulty corroborates where it
separates the lanes (によって's means/cause lane is A2 against B for grounds
and variation) but it is flat across the lanes in about half of all
families, にゃ and で included, so it cannot decide alone. Corpus frequency
and the reference dictionary's own entry order, which puts the basic sense
first, are the working evidence.

## Worked example: によって, three lanes

Before. The two outer lanes are near-duplicates in the search row, and
状況-般 claims all four jobs including both siblings':

    c11 仲介-原因   by; by means of / due to; because of / through (the agency of)
    a32 立場-根拠   in accordance with / on the basis of / under (a rule)
    d14 状況-般     by means of / depending on / owing to

After. Each lane's gloss 1 is disjoint, and every gloss is a usable
flashcard answer:

    c11 仲介-原因   by means of; through / because of; due to / by (the agent of a passive)
    a32 立場-根拠   in accordance with / on the basis of / under (a rule)
    d14 状況-般     depending on / varying with; from one … to the next

`c11` note, lane first, contrast second, the one consequential restriction
third:

> Names the means, cause, or passive agent behind an event: the method
> something is achieved by (話し合いによって解決する), the cause it resulted
> from (地震によって), or the doer in a passive (シェークスピアによって書かれ
> た). Two sibling entries take the other readings of this form: conformity
> to a rule (規則によって禁じられている) and case-to-case variation
> (人によって違う). It is not used of everyday hand tools, where で is normal.

`d14` note. The lane is one job, so the note is shorter, and the diagnostic
that separates it is the predicate, not the particle:

> Names case-to-case variation: the noun names a set of cases and the
> predicate reports difference or inconsistency (人によって違う, 天候によって
> 見えたり見えなかったり). That predicate of difference is the diagnostic;
> without one the same form reads as its siblings, means or cause or passive
> agent (地震によって), or conformity to a rule (規則によって).

## Sources

Use for verification and calibration. Never copy a gloss list, a note, or
an example sentence; satsuki's sentences are original compositions and its
wording is its own.

- 『どんなときどう使う日本語表現文型辞典』 (友松悦子ほか). Clean text.
  Best model for sense-splitting, tag brevity, and gloss economy, and the
  Japanese is reliable.
- *A Dictionary of Basic / Intermediate Japanese Grammar* (Makino &
  Tsutsui). OCR: the English is reliable, the Japanese is not. Use for
  English gloss register and for the definition-then-contrast structure.
  Note that DIJG keeps によって as a single entry with a separate
  `[REL. ni; de; no tame ni]` field; sense-splitting is satsuki's own
  burden, inherited from Tsutsuji, not something these sources model.
- Teacher-facing sites (nihongokyoshi-net, imabi, jpf.go.jp) and massif.la
  for corpus frequency, as in `author.md`.
