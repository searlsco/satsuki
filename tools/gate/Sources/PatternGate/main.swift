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

func volitionalFusion(tokens: [JapaneseToken], surfaces: [String]) -> Bool {
  for surface in Set(surfaces) where surface.hasPrefix("う") {
    let remainder = String(surface.dropFirst())
    for (index, token) in tokens.enumerated() {
      let fusedGodan = token.surface.hasSuffix("う") && token.partOfSpeech.count > 5
        && token.partOfSpeech[5].hasPrefix("意志推量")
      let auxiliary = ["よう", "う"].contains(token.surface)
        && (token.partOfSpeech.first == "助動詞"
          || (token.partOfSpeech.count > 1 && token.partOfSpeech[1] == "助動詞語幹"))
      guard fusedGodan || auxiliary else { continue }
      if remainder.isEmpty { return true }
      var following = ""
      var next = index + 1
      while next < tokens.count, following.count < remainder.count,
        tokens[next].characterRange.lowerBound == tokens[next - 1].characterRange.upperBound {
        following += tokens[next].surface
        next += 1
      }
      if following.hasPrefix(remainder) { return true }
    }
  }
  return false
}

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
      // う-onset patterns (うものなら, うが, うか…): after a godan verb the
      // volitional う fuses into the verb token (言おう), so no chunk can
      // start on the pattern's boundary. Same conjugated-away case the
      // production gate fails open on; report OPEN when a volitional token
      // is followed by the rest of the surface.
      if volitionalFusion(tokens: tokens, surfaces: dictionary.patterns(underID: pattern.l2_id).map(\.surface)) {
        print("OPEN \(tag): volitional-fused realization of \(pattern.l2_id) in 「\(plain)」")
      } else {
        print("FAIL \(tag): no chunk realizes l2 \(pattern.l2_id) in 「\(plain)」"
          + " (chunks: \(chunks.map(\.surface).joined(separator: "、")))")
        if ProcessInfo.processInfo.environment["GATE_DEBUG"] != nil {
          for token in tokens {
            print("  \(token.surface) \(token.partOfSpeech.joined(separator: ","))")
          }
        }
        failures += 1
      }
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
