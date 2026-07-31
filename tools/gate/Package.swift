// swift-tools-version: 6.2
import PackageDescription

let package = Package(
  name: "PatternGate",
  platforms: [.macOS("27.0")],
  dependencies: [
    .package(path: "../../../../searls/nihongo_kit")
  ],
  targets: [
    .executableTarget(
      name: "PatternGate",
      dependencies: [
        .product(name: "NihongoKit", package: "nihongo_kit"),
        .product(name: "NihongoKitTokenizer", package: "nihongo_kit"),
      ])
  ]
)
