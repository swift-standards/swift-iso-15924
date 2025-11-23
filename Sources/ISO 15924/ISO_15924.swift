// ISO_15924.swift
// ISO 15924
//
// Script code representation per ISO 15924

import Standards

/// Namespace for ISO 15924 script code types
///
/// ISO 15924 defines codes for writing systems (scripts):
/// - **Alpha-4**: 4-letter codes (Latn, Cyrl, Arab) - most common
/// - **Numeric**: 3-digit codes (215, 220, 160) - language-independent
///
/// ## Example
///
/// ```swift
/// // Using 4-letter code
/// let latin = try ISO_15924.Alpha4("Latn")
/// print(latin.value)  // "Latn"
///
/// // Using numeric code
/// let num215 = try ISO_15924.Numeric("215")
/// print(num215.value)  // "215"
///
/// // Conversions
/// let numeric = ISO_15924.Numeric(latin)  // "215"
/// let alpha4 = ISO_15924.Alpha4(numeric)  // "Latn"
/// ```
///
/// ## Design Pattern
///
/// This implementation follows the refined type pattern:
/// - **String-based storage**: Codes stored as validated strings
/// - **Type-safe conversions**: Compiler-enforced valid transformations
/// - **CaseIterable**: All valid codes available via `.allCases`
/// - **Static accessors**: Convenient access like `.Latn`, `.Cyrl`, `` .`215` ``
///
/// ## Data Source
///
/// Generated from authoritative Unicode Consortium ISO 15924 data.
/// Contains all 226 officially assigned script codes.
public enum ISO_15924 {}
