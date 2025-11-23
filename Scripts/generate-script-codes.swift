#!/usr/bin/env swift

import Foundation

// MARK: - Data Structures

struct Script: Codable {
    let alpha4: String
    let numeric: String
    let name: String
}

// MARK: - Swift Keywords

// NOTE: Keep in sync with Set<String>.swiftKeywords in Standards package
let swiftKeywords: Set<String> = [
    "as", "break", "case", "catch", "class", "continue", "default", "defer",
    "do", "else", "enum", "extension", "fallthrough", "false", "fileprivate",
    "for", "func", "guard", "if", "import", "in", "init", "inout", "internal",
    "is", "let", "nil", "operator", "private", "protocol", "public", "repeat",
    "return", "self", "Self", "static", "struct", "subscript", "super", "switch",
    "throw", "throws", "true", "try", "typealias", "var", "where", "while"
]

/// Escapes a code if it's a Swift keyword
func escapeIfNeeded(_ code: String) -> String {
    swiftKeywords.contains(code.lowercased()) ? "`\(code)`" : code
}

// MARK: - Load Data

func loadScripts() throws -> [Script] {
    let resourcesPath = "Sources/ISO 15924/Resources/iso-15924.json"
    let data = try Data(contentsOf: URL(fileURLWithPath: resourcesPath))
    return try JSONDecoder().decode([Script].self, from: data)
}

// MARK: - Code Generation

func generateScriptCodes(scripts: [Script]) -> String {
    var output = """
    // ISO_15924.ScriptCodes.swift
    // ISO 15924
    //
    // Script code data and mappings
    //
    // ⚠️ AUTO-GENERATED FILE - DO NOT EDIT DIRECTLY
    // Generated from JSON data files using Scripts/generate-script-codes.swift
    // To update: modify JSON files in Resources/ then run: swift Scripts/generate-script-codes.swift

    import Standards

    extension ISO_15924 {
        /// Mapping from ISO 15924 alpha-4 (4-letter) to numeric codes
        ///
        /// Complete ISO 15924 standard (226 codes) with their numeric equivalents.
        ///
        /// ## Data Source
        /// Generated from authoritative Unicode Consortium ISO 15924 data.
        internal static let alpha4ToNumeric: [Alpha4: Numeric] = [

    """

    for script in scripts.sorted(by: { $0.alpha4 < $1.alpha4 }) {
        let alpha4Escaped = escapeIfNeeded(script.alpha4)
        output += "        .\(alpha4Escaped): .`\(script.numeric)`,  // \(script.name)\n"
    }

    output += """
        ]

        /// Mapping from ISO 15924 numeric to alpha-4 (4-letter) codes
        internal static let numericToAlpha4: [Numeric: Alpha4] = {
            Dictionary(uniqueKeysWithValues: alpha4ToNumeric.map { ($1, $0) })
        }()
    }

    """

    return output
}

func generateAlpha4StaticAccessors(scripts: [Script]) -> String {
    var output = """
    // ISO_15924.Alpha4+StaticAccessors.swift
    // ISO 15924
    //
    // Static accessors for all ISO 15924 alpha-4 (4-letter) script codes
    //
    // ⚠️ AUTO-GENERATED FILE - DO NOT EDIT DIRECTLY
    // Generated from JSON data files using Scripts/generate-script-codes.swift
    // To update: modify JSON files in Resources/ then run: swift Scripts/generate-script-codes.swift

    extension ISO_15924.Alpha4 {

    """

    for script in scripts.sorted(by: { $0.alpha4 < $1.alpha4 }) {
        let codeEscaped = escapeIfNeeded(script.alpha4)
        output += "    /// \(script.name)\n"
        output += "    public static let \(codeEscaped) = ISO_15924.Alpha4(unchecked: \"\(script.alpha4)\")\n\n"
    }

    output += "}\n"
    return output
}

func generateNumericStaticAccessors(scripts: [Script]) -> String {
    var output = """
    // ISO_15924.Numeric+StaticAccessors.swift
    // ISO 15924
    //
    // Static accessors for all ISO 15924 numeric script codes
    //
    // ⚠️ AUTO-GENERATED FILE - DO NOT EDIT DIRECTLY
    // Generated from JSON data files using Scripts/generate-script-codes.swift
    // To update: modify JSON files in Resources/ then run: swift Scripts/generate-script-codes.swift

    extension ISO_15924.Numeric {

    """

    for script in scripts.sorted(by: { $0.numeric < $1.numeric }) {
        // Use backticks for numeric constants (Swift 6.2+)
        output += "    /// \(script.name)\n"
        output += "    public static let `\(script.numeric)` = ISO_15924.Numeric(unchecked: \"\(script.numeric)\")\n\n"
    }

    output += "}\n"
    return output
}

func generateAlpha4CaseIterable(scripts: [Script]) -> String {
    var output = """
    // ISO_15924.Alpha4+CaseIterable.swift
    // ISO 15924
    //
    // CaseIterable conformance for ISO 15924 alpha-4 (4-letter) codes
    //
    // ⚠️ AUTO-GENERATED FILE - DO NOT EDIT DIRECTLY
    // Generated from JSON data files using Scripts/generate-script-codes.swift
    // To update: modify JSON files in Resources/ then run: swift Scripts/generate-script-codes.swift

    extension ISO_15924.Alpha4: CaseIterable {
        public static let allCases: [ISO_15924.Alpha4] = [

    """

    let sortedScripts = scripts.sorted(by: { $0.alpha4 < $1.alpha4 })
    for (index, script) in sortedScripts.enumerated() {
        let codeEscaped = escapeIfNeeded(script.alpha4)
        let comma = index < sortedScripts.count - 1 ? "," : ""
        output += "        .\(codeEscaped)\(comma)\n"
    }

    output += """
        ]
    }

    """
    return output
}

func generateNumericCaseIterable(scripts: [Script]) -> String {
    var output = """
    // ISO_15924.Numeric+CaseIterable.swift
    // ISO 15924
    //
    // CaseIterable conformance for ISO 15924 numeric codes
    //
    // ⚠️ AUTO-GENERATED FILE - DO NOT EDIT DIRECTLY
    // Generated from JSON data files using Scripts/generate-script-codes.swift
    // To update: modify JSON files in Resources/ then run: swift Scripts/generate-script-codes.swift

    extension ISO_15924.Numeric: CaseIterable {
        public static let allCases: [ISO_15924.Numeric] = [

    """

    let sortedScripts = scripts.sorted(by: { $0.numeric < $1.numeric })
    for (index, script) in sortedScripts.enumerated() {
        let comma = index < sortedScripts.count - 1 ? "," : ""
        output += "        .`\(script.numeric)`\(comma)\n"
    }

    output += """
        ]
    }

    """
    return output
}

// MARK: - Main

do {
    print("Loading script codes...")
    let scripts = try loadScripts()
    print("Loaded \(scripts.count) scripts")

    let generatedDir = "Sources/ISO 15924/Generated"

    print("Generating code files...")

    // Generate mappings
    let scriptCodes = generateScriptCodes(scripts: scripts)
    try scriptCodes.write(toFile: "\(generatedDir)/ISO_15924.ScriptCodes.swift", atomically: true, encoding: .utf8)
    print("✓ Generated ISO_15924.ScriptCodes.swift")

    // Generate static accessors
    let alpha4Accessors = generateAlpha4StaticAccessors(scripts: scripts)
    try alpha4Accessors.write(toFile: "\(generatedDir)/ISO_15924.Alpha4+StaticAccessors.swift", atomically: true, encoding: .utf8)
    print("✓ Generated ISO_15924.Alpha4+StaticAccessors.swift")

    let numericAccessors = generateNumericStaticAccessors(scripts: scripts)
    try numericAccessors.write(toFile: "\(generatedDir)/ISO_15924.Numeric+StaticAccessors.swift", atomically: true, encoding: .utf8)
    print("✓ Generated ISO_15924.Numeric+StaticAccessors.swift")

    // Generate CaseIterable conformances
    let alpha4CaseIterable = generateAlpha4CaseIterable(scripts: scripts)
    try alpha4CaseIterable.write(toFile: "\(generatedDir)/ISO_15924.Alpha4+CaseIterable.swift", atomically: true, encoding: .utf8)
    print("✓ Generated ISO_15924.Alpha4+CaseIterable.swift")

    let numericCaseIterable = generateNumericCaseIterable(scripts: scripts)
    try numericCaseIterable.write(toFile: "\(generatedDir)/ISO_15924.Numeric+CaseIterable.swift", atomically: true, encoding: .utf8)
    print("✓ Generated ISO_15924.Numeric+CaseIterable.swift")

    print("\n✅ Code generation complete!")
    print("Generated 5 files for \(scripts.count) scripts")

} catch {
    print("❌ Error: \(error)")
    exit(1)
}
