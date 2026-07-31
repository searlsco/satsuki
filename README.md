# satsuki

An open corpus of English glosses, usage notes, and ruby-annotated example
sentences for the Japanese functional expressions (機能表現) catalogued by
the [Tsutsuji dictionary](https://tsutsuji.jnlp.org/) (Matsuyoshi & Sato).
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
- **examples**: 3 original example sentences, each with inline bracket ruby
  (`家[いえ]に帰[かえ]るとすぐに寝[ね]た。`) and a natural English
  translation

## Data layout

One JSON file per Tsutsuji semantic class under `data/`, named by class
code (`data/o11.json`). Each file carries a provenance header (pipeline
version, generating/reviewing model, date, `human_verified` flag) and its
patterns in `l2_id` order:

```json
{
  "class_code": "o11",
  "class_name": "同時性-般-トスグニ類",
  "tsutsuji_version": "1.1u",
  "provenance": { "...": "..." },
  "patterns": [
    {
      "l2_id": "0351",
      "canonical_surface": "とすぐに",
      "glosses": ["as soon as", "right after", "immediately after"],
      "usage_note": "...",
      "examples": [{ "ruby": "...", "english": "..." }]
    }
  ]
}
```

## How this corpus is made

Content is authored and reviewed by frontier language models in a pipeline
designed for scrutiny rather than trust; see
[docs/METHODOLOGY.md](docs/METHODOLOGY.md). The prompts are versioned in
[prompts/](prompts/), and every example sentence is machine-verified
against Tsutsuji's own morphological attachment rules by the tool in
[tools/gate/](tools/gate/). All sentences are original compositions;
reference sources are consulted for verification only, never copied.

Files with `"human_verified": false` have passed the mechanical gate and
model review but not human sign-off. Corrections are welcome: file an issue
or PR with the sentence or claim and, ideally, a citation or corpus
evidence (e.g. [massif.la](https://massif.la)).

## License and attribution

[CC BY-SA 4.0](LICENSE). Attribute **Searls LLC** and link to this
repository. This corpus embeds identifiers, surface forms, and taxonomy
from Tsutsuji, itself CC BY-SA 4.0; see [NOTICE.md](NOTICE.md) for upstream
attribution.
