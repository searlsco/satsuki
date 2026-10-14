# Curated supplement

The initial revision added seven senses and 24 surface realizations without
editing `data/`. The learner inventory revision appends 90 senses under
`S008` through `S097`, preserving the original IDs and realizations.
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

Before `script/release`, build the existing `tools/gate` against a compatible
reference package checkout. Set `GATE_DB` to a database built from
this exact assembled export and `GATE_DIC` to the provisioned SudachiDict.
`GATE` may name that built executable when validating a coordinated
reference package change before its release; the default is `tools/gate/.build/debug/PatternGate`.
The default legacy app-resource paths may not exist on pack-based checkouts.
The gate must pass all 1,305 original class examples and all 291 supplement examples.
Do not count an older database's successful lookup as verification of a
newly changed sense or attachment rule.


## Learner inventory revision (2026-10-14)

The appended entries are original compositions, informed by public learner
grammar indexes and lesson pages. Grammar boundaries follow contemporary
learner usage, keeping passive, causative, causative-passive, honorific,
aspect, and evidential senses distinct. Difficulty is an editorial estimate;
textbook and test-preparation indexes disagree on several level boundaries.

Existing schemas, S001–S007, and the 24 prior realizations are preserved.
The gate correction changes one original-class negative example because
the valid supplement connective ないで necessarily shadows its standalone
ない. Each new entry has three original ruby examples and remains
`human_verified: false`. Independent editorial review corrected attachment
and sense boundaries, including the distinct する bases before causative
endings. The mechanical gate now validates all 1,596 examples against a
database built from this export; lint and assembly remain separate checks.

| ID | Citation | Band | Meaning |
| --- | --- | --- | --- |
| S008 | られる | A1 | be …ed |
| S009 | させる | A1 | make someone … |
| S010 | させられる | A1 | be made to … |
| S011 | ます | A1 | do … (politely) |
| S012 | がある | A1 | there is … |
| S013 | がいる | A1 | someone is there |
| S014 | の | A1 | belonging to … |
| S015 | と | A1 | that … (quoted content) |
| S016 | よ | A1 | I am telling you |
| S017 | より | A1 | than … |
| S018 | やすい | A1 | easy to … |
| S019 | にくい | A1 | hard to … |
| S020 | 方 | A1 | how to … |
| S021 | 前に | A1 | before … |
| S022 | 時 | A1 | when … |
| S023 | たり | A1 | do things such as … |
| S024 | すぎる | A1 | do too much |
| S025 | になる | A1 | become … |
| S026 | にする | A1 | make something … |
| S027 | しろ | A1 | do …! |
| S028 | られる | A1 | do … (respectfully) |
| S029 | になる | A1 | perform an action respectfully |
| S030 | する | A1 | perform an action humbly |
| S031 | てみる | A1 | try doing … |
| S032 | ないでください | A1 | please do not … |
| S033 | がる | A1 | show signs of feeling … |
| S034 | うちに | A2 | before the chance passes |
| S035 | ほど | A2 | the more …, the more … |
| S036 | こそ | A2 | this very … |
| S037 | 最中に | A2 | right in the middle of … |
| S038 | に比べて | A2 | compared with … |
| S039 | というより | A2 | rather … than … |
| S040 | て初めて | A2 | only after … |
| S041 | ついでに | A2 | while already doing … |
| S042 | おきに | A2 | at intervals of … |
| S043 | だらけ | A2 | covered in … |
| S044 | 向き | A2 | suited to … |
| S045 | 向け | A2 | intended for … |
| S046 | 切る | A2 | do all the way to the end |
| S047 | 切れない | A2 | cannot finish all of … |
| S048 | かける | A2 | begin but not finish … |
| S049 | ふりをする | A2 | pretend to … |
| S050 | かねる | B | cannot bring oneself to … |
| S051 | かねない | B | could end up … |
| S052 | 次第 | A2 | as soon as … is complete |
| S053 | 次第で | B | depending entirely on … |
| S054 | に限る | A2 | nothing beats … |
| S055 | に越したことはない | B | … is preferable if possible |
| S056 | 恐れがある | B | there is a risk of … |
| S057 | ものがある | B | has a distinctly … quality |
| S058 | ことなく | B | without once …ing |
| S059 | に基づいて | B | grounded in … |
| S060 | に沿って | B | following the course of … |
| S061 | に伴って | B | along with the change in … |
| S062 | きらいがある | C | has an unfortunate tendency to … |
| S063 | を余儀なくされる | C | is compelled to … |
| S064 | てからというもの | C | ever since that turning point … |
| S065 | を皮切りに | C | starting the series with … |
| S066 | かたわら | C | alongside one’s main activity … |
| S067 | を踏まえて | C | taking those facts into account … |
| S068 | に即して | C | in keeping with actual conditions … |
| S069 | に照らして | C | assessed against … |
| S070 | とあって | C | given that special circumstance … |
| S071 | てやまない | C | never stops sincerely … |
| S072 | ないで | A1 | without doing … |
| S073 | こと | A1 | the act of … |
| S074 | ようとする | A2 | try to … |
| S075 | たて | A2 | freshly …ed |
| S076 | とおり | A2 | just as … |
| S077 | がたい | A2 | hard to … |
| S078 | がち | A2 | tend to … |
| S079 | 気味 | A2 | a little … |
| S080 | っぽい | A2 | -ish; having a … quality |
| S081 | っぱなし | A2 | leave … as it is |
| S082 | 合う | A2 | do … with each other |
| S083 | ことから | A2 | from the fact that … |
| S084 | はもちろん | A2 | not only … but also … |
| S085 | に代わって | A2 | in place of … |
| S086 | げ | B | with an air of … |
| S087 | 抜く | B | see … through despite difficulty |
| S088 | を契機に | B | taking … as a turning point |
| S089 | なくて済む | B | get by without doing … |
| S090 | っこない | B | has absolutely no chance of … |
| S091 | 抜きで | B | leaving … out |
| S092 | をもとに | B | using … as source material |
| S093 | をおいて | C | no suitable alternative to … |
| S094 | の極み | C | the utmost degree of … |
| S095 | を顧みず | C | without regard for … |
| S096 | をものともせず | C | undeterred by the obstacle of … |
| S097 | もさることながら | C | besides the acknowledged point of … |

Connection rules are candidate filters. Some endings fuse into a verb,
adjective, or compound noun token, so examples use forms whose boundaries
the tokenizer exposes. S027 retains the imperative sense under the
whole-token citation しろ; regular imperatives require conjugation-aware
recognition. Contracted causative-passives likewise fuse into the verb,
so S010 examples use uncontracted forms. Inflection stems such as かけ,
合っ, and てみ leave following た-led patterns available to the chunker.
The S029 filter checks the preceding お or ご and accepts nominalized
verb stems; social context still determines the respectful reading. The
humble お…する frame still needs prefix and context review, and をおいて
requires a following denial of alternatives. Lexical compounds can share
grammatical suffixes, so passing attachment does not establish a sense.
