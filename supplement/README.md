# Curated supplement

This set implements the initial scope approved in
[PaperWeight #41](https://github.com/searls/paper_weight/issues/41).
It adds seven senses and 24 surface realizations without editing `data/`.
New sense IDs are stable; append future senses rather than renumbering.
The draft's author attribution is preserved. Independent review is recorded
only after it actually completes; `human_verified` stays false without human
sign-off.

| Requested point | Representation |
| --- | --- |
| Prohibitive な, including すんな | S001; the matcher must normalize contracted verb attachment |
| はしない / やしない / ゃしない | S002, including the fused boundary in 行きゃしない |
| Sentence-final さ | S003 |
| たびに / 度に | S004 |
| ことがある (occasional events) | S005; past experience remains Tsutsuji's separate sense |
| ように (purpose) | S006; similarity realization extends 3242 |
| そうだ (appearance) | S007; hearsay realizations extend 3361 |
| ところだ | Realizations of 0481/0482/1361/1412, retaining their distinct senses |
| べきだ / わけだ / はずだ / つもりだ | Realizations of 1581/1621/1631/1851 |
| をください | Realization of 2221 |
| てください / でください | Already in Tsutsuji; no duplicate supplement rows |

## Editorial checks

Consulted on 2026-09-28 to check meaning and attachment, not to copy example
sentences:

- [Bunpro: prohibitive な](https://bunpro.jp/grammar_points/な): dictionary-form attachment and blunt negative command.
- [にほんご部: やしない](https://nihongobu.net/n1-yashinai/): emphatic negative construction.
- [Nihongoいちにのさん: sentence-final さ](https://www.ichi2no3.com/2022/09/blog-post.html): offhand assertion and register, distinct from mid-sentence filler.
- [Bunpro: たびに](https://bunpro.jp/grammar_points/たびに): dictionary form or noun plus の.
- [毎日のんびり日本語教師: ことがある](https://mainichi-nonbiri.com/grammar/n3-kotogaaru/): occasional events after dictionary or negative verb forms.
- [Bunpro: ように](https://bunpro.jp/grammar_points/ように): intended result, often negative or potential verbs.
- [毎日のんびり日本語教師: そうだ](https://mainichi-nonbiri.com/grammar/n4-souda/): appearance versus hearsay and their different attachments.

The connection rules are machine-readable candidate filters, not complete
semantic analyses. The normal matcher and contextual review still decide
whether a candidate fits. In particular, unconstrained `9090` on ゃしない
represents a boundary fused into the preceding verb, not free attachment.

## Verification and release

Run `script/lint` and `python3 -m unittest discover -s tests`.
`script/assemble <version>` preserves every class and adds ruby-stripped
`text` to the supplement's examples just as it does to class examples.

Before `script/release`, build the existing `tools/gate` against a NihongoKit
checkout supporting this supplement. Set `GATE_DB` to a database built from
this exact assembled export and `GATE_DIC` to the provisioned SudachiDict.
`GATE` may name that built executable when validating a coordinated
NihongoKit change before its release; the default is `tools/gate/.build/debug/PatternGate`.
The default legacy app-resource paths may not exist on pack-based checkouts.
The gate must pass all 1,305 existing examples and all 21 supplement examples.
Do not count an older database's successful lookup as verification of a
newly changed sense or attachment rule.
