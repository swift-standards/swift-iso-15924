// swift-tools-version: 6.3.3

import PackageDescription

extension String {
    static let iso15924: Self = "ISO 15924"
}

extension String { var tests: Self { self + " Tests" } }

extension Target.Dependency {
    static var iso15924: Self { .target(name: .iso15924) }
    static var standards: Self {
        .product(name: "Standard Library Extensions", package: "swift-standard-library-extensions")
    }
    static var ascii: Self {
        .product(name: "ASCII Primitives", package: "swift-ascii-primitives")
    }
}

let package = Package(
    name: "swift-iso-15924",
    platforms: [
        .macOS(.v26),
        .iOS(.v26),
        .tvOS(.v26),
        .watchOS(.v26),
    ],
    products: [
        .library(name: "ISO 15924", targets: ["ISO 15924"])
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-primitives/swift-standard-library-extensions.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-primitives/swift-ascii-primitives.git",
            branch: "main"
        ),
    ],
    targets: [
        .target(
            name: "ISO 15924",
            dependencies: [
                .standards,
                .ascii,
            ]
        ),
        .testTarget(
            name: "ISO 15924 Tests",
            dependencies: [
                "ISO 15924"
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableExperimentalFeature("SuppressedAssociatedTypes"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
