// ISO_15924.Numeric.swift
// ISO 15924
//
// Numeric script code (ISO 15924 numeric)

import INCITS_4_1986
import Standards

extension ISO_15924 {
    /// Numeric script code per ISO 15924 numeric
    ///
    /// Refined type representing a valid 3-digit numeric script code.
    /// Common codes like "215" (Latin), "220" (Cyrillic), "160" (Arabic), etc.
    ///
    /// ## Validation
    ///
    /// - Exactly 3 ASCII digits
    /// - Must be a recognized ISO 15924 numeric code
    ///
    /// ## Example
    ///
    /// ```swift
    /// let latin = try ISO_15924.Numeric("215")
    /// print(latin.value)  // "215"
    /// ```
    public struct Numeric: Sendable, Equatable, Hashable {
        /// The three-digit numeric code value
        public let value: String

        /// Creates a numeric code (partial function)
        ///
        /// Validates that the string is a recognized ISO 15924 numeric code.
        ///
        /// - Parameter value: Three-digit numeric code string
        /// - Throws: `Numeric.Error` if invalid
        public init(_ value: some StringProtocol) throws {
            let normalized = String(value)

            // Validate length
            guard normalized.count == 3 else {
                throw Numeric.Error.invalidCodeLength(normalized.count)
            }

            // Validate ASCII digits only
            guard normalized.allSatisfy({ $0.ascii.isDigit }) else {
                throw Numeric.Error.invalidCharacters(normalized)
            }

            // Validate it's a recognized code
            guard Self.validCodes.contains(normalized) else {
                throw Numeric.Error.invalidNumericCode(normalized)
            }

            self.value = normalized
        }
    }
}

extension ISO_15924.Numeric {
    /// Creates a numeric code without validation (internal use only)
    ///
    /// - Warning: Only use when the value is guaranteed to be valid
    /// - Parameter value: Pre-validated numeric code
    internal init(unchecked value: String) {
        self.value = value
    }

    /// Set of valid ISO 15924 numeric (3-digit) code strings for validation
    ///
    /// Computed from `allCases` for consistency.
    internal static let validCodes: Set<String> = {
        Set(allCases.map { $0.value })
    }()
}

// MARK: - String Representation

extension ISO_15924.Numeric: CustomStringConvertible {
    public var description: String { value }
}

// MARK: - Codable

extension ISO_15924.Numeric: Codable {
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

extension ISO_15924.Numeric {
    /// Converts a four-letter code to its numeric equivalent (total function)
    ///
    /// This is the authoritative conversion from ISO 15924 alpha-4 to numeric.
    /// All ISO 15924 alpha-4 codes have corresponding numeric codes by definition,
    /// so this conversion never fails.
    ///
    /// ## Performance
    /// - Time complexity: O(1) via hash table lookup
    /// - Space complexity: O(1)
    ///
    /// - Parameter alpha4: Four-letter script code
    public init(_ alpha4: ISO_15924.Alpha4) {
        // Performance: O(1) dictionary lookup
        // Force unwrap is safe: all ISO 15924 alpha-4 codes have numeric equivalents
        let numeric = ISO_15924.alpha4ToNumeric[alpha4]!
        self = numeric
    }
}
