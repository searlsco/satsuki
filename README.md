# satsuki

An open corpus of English glosses, usage notes, and ruby-annotated example
sentences for the Japanese functional expressions (機能表現) catalogued by
the [Tsutsuji dictionary](https://sites.google.com/edu.teu.ac.jp/cl-lab/研究/言語資源/日本語機能表現辞書つつじ) (Matsuyoshi & Sato).
Tsutsuji is a pure form-and-attachment layer; satsuki is the meaning layer
grown on top of it. (Satsuki is the azalea that blooms right after tsutsuji
each spring.)

Tsutsuji groups its 16,801 surface forms into 435 abstract patterns, keyed
by what this corpus calls `l2_id`. satsuki enriches each abstract pattern
with:

- **glosses**: 1–3 short English dictionary-style senses
- **usage_note**: the disambiguation guidance a learner needs to choose this
  pattern over its near-synonyms (nuance, register, restrictions,
  attachment quirks)
- **sense_rank**: reading order among the patterns sharing this surface,
  `1` for the sense a learner meets first and most often. Tsutsuji files
  one surface under several semantic classes when it has several senses
  (によって three times); those siblings are ranked `1..n`, and a surface
  with no sibling is simply its own `1`. Consumers that merge same-surface
  patterns into a single entry should lead with rank 1 and order the rest
  by rank; Tsutsuji difficulty cannot recover this on its own, being flat
  across the lanes in about half of all such families
- **examples**: 3 original example sentences, each with inline bracket ruby
  (`家[いえ]に帰[かえ]るとすぐに寝[ね]た。`) and a natural English
  translation

## Data layout

One JSON file per Tsutsuji semantic class under `data/`, named by class
code (`data/o11.json`). Class codes are case-sensitive but common
filesystems are not, so uppercase-initial codes double their letter in the
filename: class `A11` lives at `data/AA11.json` (the `class_code` field
inside is always authoritative). Each file carries a provenance header (pipeline
version, generating/reviewing model, date) and its patterns in `l2_id`
order, each with its own `human_verified` flag:

```json
{
  "satsuki_schema": 2,
  "class_code": "o11",
  "class_name": "同時性-般-トスグニ類",
  "tsutsuji_version": "1.1u",
  "provenance": { "...": "..." },
  "patterns": [
    {
      "l2_id": "0351",
      "canonical_surface": "とすぐに",
      "sense_rank": 1,
      "glosses": ["as soon as", "right after", "immediately after"],
      "usage_note": "...",
      "human_verified": false,
      "examples": [{ "ruby": "...", "english": "..." }]
    }
  ]
}
```

## How this corpus is made

### Curated supplement

`supplement/patterns.json` adds common expressions absent from Tsutsuji.
It ships as the additive `supplement` member of the schema-2 export, with
its own `satsuki_supplement_schema: 1`. Existing `classes` are unchanged.
Consumers may ignore the supplement until they support it.

The seven new senses have stable `S001` through `S007` IDs, a canonical
surface, reading, attachment description, difficulty, register, glosses,
usage note, ranked sense, and three original examples. Each `surfaces`
entry carries the realized form and a Tsutsuji-style left connection pair.
`connections` defines extra two-character IDs beginning with `s`; these
reuse Tsutsuji's feature vocabulary. Supplement difficulty is an editorial
estimate on Tsutsuji's scale, not an official JLPT classification.

The 24 `realizations` add missing full forms to existing Tsutsuji senses,
such as はずだ beside はず. They reuse the original sense's meaning and
examples without replacing its rows. てください already exists in
Tsutsuji, so it is not duplicated. Ingesters must assign S-prefixed row IDs
to these realizations too, while retaining their existing `l2_id` link.
See [supplement/README.md](supplement/README.md) for scope and verification
sources. The supplement has separate provenance and remains subject to
the same review and mechanical example gates as the original corpus.

Content is authored and reviewed by frontier language models in a pipeline
designed for scrutiny rather than trust; see
[docs/METHODOLOGY.md](docs/METHODOLOGY.md). The prompts are versioned in
[prompts/](prompts/), and every example sentence is machine-verified
against Tsutsuji's own morphological attachment rules by the tool in
[tools/gate/](tools/gate/). All sentences are original compositions;
reference sources are consulted for verification only, never copied.

Patterns with `"human_verified": false` have passed the mechanical gate
and model review but not human sign-off; the flag flips per pattern as
review happens. Corrections are welcome: file an issue
or PR with the sentence or claim and, ideally, a citation or corpus
evidence (e.g. [massif.la](https://massif.la)).

## License and attribution

[CC BY-SA 4.0](LICENSE). Attribute **Searls LLC** and link to this
repository. This corpus embeds identifiers, surface forms, and taxonomy
from Tsutsuji, itself CC BY-SA 4.0; see [NOTICE.md](NOTICE.md) for upstream
attribution.
