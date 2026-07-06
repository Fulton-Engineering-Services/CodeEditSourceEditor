// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CodeEditSourceEditor",
    platforms: [.macOS(.v13)],
    products: [
        // A source editor with useful features for code editing.
        .library(
            name: "CodeEditSourceEditor",
            targets: ["CodeEditSourceEditor"]
        )
    ],
    dependencies: [
        // A fast, efficient, text view for code.
        // FES fork with extensible menu items provider
        .package(
            url: "https://github.com/Fulton-Engineering-Services/CodeEditTextView.git",
            exact: "0.12.1"
        ),
        // tree-sitter languages
        // FES fork: upstream 0.1.20 plus the CodeLanguage.queryURL fix (dropped the
        // redundant "Resources/" path component that broke every highlight/fold/indent
        // query load). Pointing at the fork here keeps a single package identity for
        // "codeeditlanguages" across the whole graph, so consumers no longer hit the
        // SwiftPM "Conflicting identity" warning from mixing this URL with the fork.
        .package(
            url: "https://github.com/Fulton-Engineering-Services/CodeEditLanguages.git",
            exact: "0.1.20"
        ),
        // CodeEditSymbols
        // FES fork: upstream 0.2.3 base plus PR #21 (Process symbol asset catalog) so
        // Symbols.xcassets is declared as a target resource and Bundle.module is
        // synthesized under plain swift build. Same identity as upstream to avoid a
        // conflicting-identity warning in consumers.
        .package(
            url: "https://github.com/Fulton-Engineering-Services/CodeEditSymbols.git",
            exact: "0.2.3-fes.1"
        ),
        // SwiftLint
        .package(
            url: "https://github.com/lukepistrol/SwiftLintPlugin",
            from: "0.2.2"
        ),
        // Rules for indentation, pair completion, whitespace
        .package(
            url: "https://github.com/ChimeHQ/TextFormation",
            from: "0.8.2"
        ),
        .package(url: "https://github.com/pointfreeco/swift-custom-dump", from: "1.0.0")
    ],
    targets: [
        // A source editor with useful features for code editing.
        .target(
            name: "CodeEditSourceEditor",
            dependencies: [
                "CodeEditTextView",
                "CodeEditLanguages",
                "TextFormation",
                "CodeEditSymbols"
            ],
            plugins: [
                .plugin(name: "SwiftLint", package: "SwiftLintPlugin")
            ]
        ),

        // Tests for the source editor
        .testTarget(
            name: "CodeEditSourceEditorTests",
            dependencies: [
                "CodeEditSourceEditor",
                "CodeEditLanguages",
                .product(name: "CustomDump", package: "swift-custom-dump")
            ],
            plugins: [
                .plugin(name: "SwiftLint", package: "SwiftLintPlugin")
            ]
        ),
    ]
)
