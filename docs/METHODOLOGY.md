# Methodology

satsuki content is produced by a model pipeline built so that every claim
and sentence can be re-derived, re-checked, or superseded later — by
better models, by corpus tooling, or by humans. Nothing in `data/` is
trusted because a model said it; it is shipped because it survived the
stages below, and its provenance header says exactly which pipeline
produced it.

## Pipeline (v1)

One batch = one Tsutsuji semantic class (its near-synonymous patterns are
authored and reviewed together, because differentiating siblings is most
of the value).

1. **Author** (`prompts/author.md`): a frontier model (pilot:
   claude-opus-5) with web search writes glosses, usage notes, and 3
   original example sentences per pattern. The prompt embeds the batch's
   corpus data: surfaces, readings, difficulty, register, and the
   left-connection (attachment) rule expanded into plain language.
2. **Mechanical gate** (`tools/gate/`): a deterministic Swift program
   validates every example with no model involvement:
   - the ruby parses under NihongoKit's `RubyNotation` grammar
   - the ruby-stripped sentence contains a `PatternChunker`-recognized
     realization of the claimed `l2_id` (SudachiDict morpheme boundaries,
     longest match)
   - the morphemes preceding the span satisfy the pattern's Tsutsuji
     left-connection rule via `PatternAttachmentGate` (`violated` fails;
     `indeterminate` passes open and is reported)
   Failures go back to the author with the exact reason.
3. **Cold review** (`prompts/reviewer.md`): a fresh model instance that
   did not author the batch judges naturalness, semantic fit, English
   quality, in-context ruby readings, and — with explicit skepticism —
   every absolute claim and sibling cross-reference in the usage notes,
   verifying against reference sources. It also reviews the batch as a
   set (shared sentence skeletons across near-synonyms are defects).
   Every "revise" verdict must carry a directly applicable fix.
4. **Apply and re-gate**: fixes are applied and the mechanical gate runs
   again. Only an all-clear batch lands in `data/`.
5. **Cross-class disambiguation**: batching is per class, but Tsutsuji
   files the same surface under multiple classes when it has different
   senses (をもって as instrument vs standard), and those senses land in
   different batches with authors blind to each other. A final pass
   groups every same-surface family (canonical surfaces normalized for
   the adnominal の), one agent per file-disjoint group, to sharpen
   glosses/notes into explicit contrasts and replace any example that
   exemplifies a sibling sense. In the v1 run this changed 36 of 62
   families.

## Pre-flight (learned the hard way)

Before any fleet run, test the mechanical gate against one hand-written
example per morphological family in the work list (dictionary-form
attachments, た-fusions, volitional う/よう-onsets, …). The v1 run paid
for skipping this: う-onset patterns cannot be chunked after godan verbs
(言おう fuses into one morpheme) and the gate needed surgery mid-run.
Likewise, design artifact naming around identifier quirks up front —
case-sensitive Tsutsuji class codes on a case-insensitive filesystem
silently overwrote 39 files until filenames doubled their initial letter.

## Design choices worth knowing

- **Original sentences only.** Reference sites and corpora are consulted
  for verification; sentences are never copied from any source.
- **Examples obey the corpus, notes describe reality.** If real usage
  permits an attachment Tsutsuji's rule doesn't license (卒業と同時に),
  that fact lives in the usage note; examples stay machine-checkable.
- **Absolutes must be sourced.** Pilot experience: model errors
  concentrate in usage notes, specifically overclaimed restrictions and
  misdirected sibling comparisons. The reviewer fact-checks every
  "never/only/cannot".
- **Provenance over trust.** Each data file records pipeline version,
  models, and date; each pattern carries `human_verified: false` until a
  human signs off on it. "Re-review everything authored by model X under pipeline v1"
  is meant to be a mechanical operation forever.

## Known limitations

- The attachment gate fails open on `indeterminate` (IPADIC↔UniDic
  mapping abstentions), so a sentence can pass the gate without the gate
  having proven attachment.
- Reviewer verification leans on teacher-facing web sources plus
  massif.la corpus checks; it is not native-speaker sign-off.
- Tsutsuji's own taxonomy (difficulty, register, connection rules) is
  taken as ground truth even where real usage is broader.
