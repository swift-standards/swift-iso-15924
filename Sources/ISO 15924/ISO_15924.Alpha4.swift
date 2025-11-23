// ISO_15924.Alpha4.swift
// ISO 15924
//
// Four-letter script code (ISO 15924 alpha-4)

import Standards
import INCITS_4_1986

extension ISO_15924 {
    /// Four-letter script code per ISO 15924
    ///
    /// Refined type representing a valid 4-letter script code.
    /// Common codes like "Latn", "Cyrl", "Arab", "Hans", etc.
    ///
    /// ## Validation
    ///
    /// - Exactly 4 ASCII letters
    /// - Title case (first letter uppercase, rest lowercase)
    /// - Must be a recognized ISO 15924 code
    ///
    /// ## Example
    ///
    /// ```swift
    /// let latin = try ISO_15924.Alpha4("Latn")
    /// print(latin.value)  // "Latn"
    /// ```
    public struct Alpha4: Sendable, Equatable, Hashable {
        /// The four-letter code value
        public let value: String

        /// Creates a four-letter code (partial function)
        ///
        /// Validates that the string is a recognized ISO 15924 alpha-4 code.
        ///
        /// - Parameter value: Four-letter code string
        /// - Throws: `Alpha4.Error` if invalid
        public init(_ value: some StringProtocol) throws {
            // Normalize to title case
            let normalized = String(value.prefix(1).uppercased() + value.dropFirst().lowercased())

            // Validate length
            guard normalized.count == 4 else {
                throw Alpha4.Error.invalidCodeLength(normalized.count)
            }

            // Validate ASCII letters only
            guard normalized.allSatisfy({ $0.ascii.isLetter }) else {
                throw Alpha4.Error.invalidCharacters(normalized)
            }

            // Validate it's a recognized code
            guard Self.validCodes.contains(normalized) else {
                throw Alpha4.Error.invalidAlpha4Code(normalized)
            }

            self.value = normalized
        }
    }
}

extension ISO_15924.Alpha4 {
    /// Creates a four-letter code without validation (internal use only)
    ///
    /// - Warning: Only use when the value is guaranteed to be valid
    /// - Parameter value: Pre-validated four-letter code
    internal init(unchecked value: String) {
        self.value = value
    }

    /// Set of valid ISO 15924 alpha-4 (4-letter) code strings for validation
    ///
    /// Computed from `allCases` for consistency.
    internal static let validCodes: Set<String> = {
        Set(allCases.map { $0.value })
    }()
}

// MARK: - String Representation

extension ISO_15924.Alpha4: CustomStringConvertible {
    public var description: String { value }
}

// MARK: - Codable

extension ISO_15924.Alpha4: Codable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(value)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        try self.init(string)
    }
}

// MARK: - Conversions

extension ISO_15924.Alpha4 {
    /// Converts a numeric code to its four-letter equivalent (total function)
    ///
    /// This is the authoritative conversion from ISO 15924 numeric to alpha-4.
    /// All ISO 15924 numeric codes have corresponding alpha-4 codes by definition,
    /// so this conversion never fails.
    ///
    /// ## Performance
    /// - Time complexity: O(1) via hash table lookup
    /// - Space complexity: O(1)
    ///
    /// - Parameter numeric: Numeric script code
    public init(_ numeric: ISO_15924.Numeric) {
        // Performance: O(1) dictionary lookup
        // Force unwrap is safe: all ISO 15924 numeric codes have alpha-4 equivalents
        let alpha4 = ISO_15924.numericToAlpha4[numeric]!
        self = alpha4
    }
}
