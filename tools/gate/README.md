# PatternGate

Deterministic validation of satsuki example sentences against Tsutsuji's
morphology. Depends on a sibling checkout of
[nihongo_kit](https://github.com/searls/nihongo_kit) (expected at `../../../../searls/nihongo_kit` relative to this directory, i.e. a `~/code/searls/nihongo_kit` checkout)
and needs two artifacts nihongo_kit's `script/build_references` produces:
the bundled `dictionary.sqlite` and a SudachiDict `system_small.dic`.

```sh
swift build
.build/debug/PatternGate <batch.json> <dictionary.sqlite> <system_small.dic>
```

Per example it verifies: the ruby parses (`RubyNotation`), the sentence
contains a chunker-recognized realization of the claimed `l2_id`
(`PatternChunker` over Sudachi short-granularity morphemes), and the
preceding morphemes satisfy the pattern's left-connection rule
(`PatternAttachmentGate`; `violated` fails, `indeterminate` passes open
and is printed as `OPEN`). Exit 0 on all clear, 1 with per-example `FAIL`
lines otherwise.
