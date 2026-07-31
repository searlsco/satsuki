import Foundation
import NihongoKit
import NihongoKitTokenizer

// Mechanical validation of authored pattern examples:
//   1. ruby parses under RubyNotation
//   2. the plain sentence contains a chunker-recognized realization of the
//      claimed l2 pattern
//   3. the morphemes preceding the span satisfy the Tsutsuji left-connection
//      rule (violated = fail; indeterminate = pass-open, reported)
// Usage: PatternGate <draft.json> <dictionary.sqlite> <sudachi.dic>

struct Example: Decodable {
  let ruby: String
  let english: String
}
struct Pattern: Decodable {
  let l2_id: String
  let canonical_surface: String
  let glosses: [String]
  let usage_note: String?
  let examples: [Example]
}
struct Draft: Decodable { let patterns: [Pattern] }

let args = CommandLine.arguments
guard args.count == 4,
  let dictionary = JapaneseDictionary(url: URL(fileURLWithPath: args[2])),
  let tokenizer = SudachiTokenizer(
    dictionaryURL: URL(fileURLWithPath: args[3]), granularity: .short)
else {
  FileHandle.standardError.write(Data("usage: PatternGate <draft.json> <dictionary.sqlite> <sudachi.dic>\n".utf8))
  exit(64)
}

let draft = try JSONDecoder().decode(
  Draft.self, from: Data(contentsOf: URL(fileURLWithPath: args[1])))
let chunker = PatternChunker(dictionary: dictionary)
let gate = PatternAttachmentGate(dictionary: dictionary)

var failures = 0
for pattern in draft.patterns {
  if pattern.examples.count != 3 {
    print("FAIL \(pattern.l2_id): expected 3 examples, got \(pattern.examples.count)")
    failures += 1
  }
  for (index, example) in pattern.examples.enumerated() {
    let tag = "\(pattern.l2_id)#\(index + 1)"
    let segments: [FuriganaSegment]
    do {
      segments = try RubyNotation.parse(example.ruby)
    } catch {
      print("FAIL \(tag): ruby does not parse — \(error)")
      failures += 1
      continue
    }
    for segment in segments where !segment.reading.isEmpty {
      let hasKanji = segment.base.unicodeScalars.contains {
        (0x3400...0x9FFF).contains(Int($0.value)) || (0xF900...0xFAFF).contains(Int($0.value))
      }
      if !hasKanji {
        print("WARN \(tag): reading bracket on non-kanji base 「\(segment.base)」")
      }
    }
    let plain = RubyNotation.writtenForm(of: segments)
    let tokens = tokenizer.tokens(in: plain)
    let chunks = chunker.chunks(in: tokens)
    guard let chunk = chunks.first(where: { $0.patterns.contains { $0.l2ID == pattern.l2_id } })
    else {
      print("FAIL \(tag): no chunk realizes l2 \(pattern.l2_id) in 「\(plain)」"
        + " (chunks: \(chunks.map(\.surface).joined(separator: "、")))")
      failures += 1
      continue
    }
    let entries = chunk.patterns.filter { $0.l2ID == pattern.l2_id }
    let preceding = Array(tokens[..<chunk.tokenRange.lowerBound])
    let verdicts = entries.map { gate.verdict(preceding: preceding, for: $0) }
    if verdicts.allSatisfy({ $0 == .violated }) {
      print("FAIL \(tag): attachment violated before 「\(chunk.surface)」 in 「\(plain)」"
        + " (preceding: \(preceding.suffix(2).map(\.surface).joined(separator: "、")))")
      failures += 1
    } else if !verdicts.contains(.satisfied) {
      print("OPEN \(tag): attachment indeterminate before 「\(chunk.surface)」 in 「\(plain)」")
    } else {
      print("PASS \(tag): 「\(chunk.surface)」 in 「\(plain)」")
    }
  }
}
print(failures == 0 ? "ALL CLEAR" : "\(failures) failure(s)")
exit(failures == 0 ? 0 : 1)
