// ISO_15924.Error.swift
// ISO 15924
//
// Error types for ISO 15924 validation

import Standards

extension ISO_15924 {
    /// Errors that can occur when working with script codes
    public enum Error: Swift.Error, Sendable, Equatable {
        /// Code length is invalid (must be 3 or 4)
        case invalidCodeLength(Int)

        /// Code contains invalid characters
        case invalidCharacters(String)

        /// Four-letter code is not recognized
        case invalidAlpha4Code(String)

        /// Numeric code is not recognized
        case invalidNumericCode(String)
    }
}

extension ISO_15924.Alpha4 {
    public enum Error: Swift.Error, Sendable, Equatable {
        /// Code length is invalid (must be 4)
        case invalidCodeLength(Int)

        /// Code contains invalid characters (must be ASCII letters only)
        case invalidCharacters(String)

        /// Four-letter code is not recognized
        case invalidAlpha4Code(String)
    }
}

extension ISO_15924.Numeric {
    public enum Error: Swift.Error, Sendable, Equatable {
        /// Code length is invalid (must be 3)
        case invalidCodeLength(Int)

        /// Code contains invalid characters (must be ASCII digits only)
        case invalidCharacters(String)

        /// Numeric code is not recognized
        case invalidNumericCode(String)
    }
}
