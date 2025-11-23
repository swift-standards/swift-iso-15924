// ISO15924Tests.swift
// ISO 15924 Tests

import Testing
@testable import ISO_15924
import Foundation

@Suite("ISO 15924 Script Codes")
struct ISO15924Tests {

    // MARK: - Alpha4 Tests

    @Test
    func `Alpha4: Valid 4-letter codes`() throws {
        let latin = try ISO_15924.Alpha4("Latn")
        #expect(latin.value == "Latn")

        let cyrillic = try ISO_15924.Alpha4("CYRL")  // Test case normalization
        #expect(cyrillic.value == "Cyrl")

        let arabic = try ISO_15924.Alpha4("arab")  // Test lowercase
        #expect(arabic.value == "Arab")
    }

    @Test
    func `Alpha4: Invalid length`() {
        #expect(throws: ISO_15924.Alpha4.Error.invalidCodeLength(3)) {
            try ISO_15924.Alpha4("Lat")
        }

        #expect(throws: ISO_15924.Alpha4.Error.invalidCodeLength(5)) {
            try ISO_15924.Alpha4("Latin")
        }

        #expect(throws: ISO_15924.Alpha4.Error.invalidCodeLength(0)) {
            try ISO_15924.Alpha4("")
        }
    }

    @Test
    func `Alpha4: Invalid characters`() {
        #expect(throws: ISO_15924.Alpha4.Error.invalidCharacters("Lat1")) {
            try ISO_15924.Alpha4("Lat1")
        }

        #expect(throws: ISO_15924.Alpha4.Error.invalidCharacters("Lat-")) {
            try ISO_15924.Alpha4("Lat-")
        }

        #expect(throws: ISO_15924.Alpha4.Error.invalidCharacters("Lat ")) {
            try ISO_15924.Alpha4("Lat ")
        }
    }

    @Test
    func `Alpha4: Unrecognized code`() {
        // Note: Zzzz is actually valid (Code for uncoded script)
        #expect(throws: ISO_15924.Alpha4.Error.invalidAlpha4Code("Xxxx")) {
            try ISO_15924.Alpha4("Xxxx")
        }

        #expect(throws: ISO_15924.Alpha4.Error.invalidAlpha4Code("Qqqq")) {
            try ISO_15924.Alpha4("Qqqq")
        }
    }

    @Test
    func `Alpha4: Common static constants`() {
        #expect(ISO_15924.Alpha4.Latn.value == "Latn")
        #expect(ISO_15924.Alpha4.Cyrl.value == "Cyrl")
        #expect(ISO_15924.Alpha4.Arab.value == "Arab")
        #expect(ISO_15924.Alpha4.Hans.value == "Hans")
        #expect(ISO_15924.Alpha4.Hant.value == "Hant")
        #expect(ISO_15924.Alpha4.Hebr.value == "Hebr")
        #expect(ISO_15924.Alpha4.Deva.value == "Deva")
        #expect(ISO_15924.Alpha4.Jpan.value == "Jpan")
    }

    @Test
    func `Alpha4: String conversion`() {
        #expect(ISO_15924.Alpha4.Latn.description == "Latn")
        #expect(String(describing: ISO_15924.Alpha4.Cyrl) == "Cyrl")
    }

    @Test
    func `Alpha4: Equality and hashing`() {
        let latin1 = ISO_15924.Alpha4.Latn
        let latin2 = ISO_15924.Alpha4.Latn
        #expect(latin1 == latin2)
        #expect(latin1.hashValue == latin2.hashValue)

        let cyrillic = ISO_15924.Alpha4.Cyrl
        #expect(latin1 != cyrillic)
    }

    @Test
    func `Alpha4: Codable round-trip`() throws {
        let original = ISO_15924.Alpha4.Latn
        let encoder = JSONEncoder()
        let data = try encoder.encode(original)
        let decoder = JSONDecoder()
        let decoded = try decoder.decode(ISO_15924.Alpha4.self, from: data)
        #expect(decoded == original)
        #expect(decoded.value == "Latn")
    }

    // MARK: - Numeric Tests

    @Test
    func `Numeric: Valid numeric codes`() throws {
        let latin = try ISO_15924.Numeric("215")
        #expect(latin.value == "215")

        let cyrillic = try ISO_15924.Numeric("220")
        #expect(cyrillic.value == "220")

        let arabic = try ISO_15924.Numeric("160")
        #expect(arabic.value == "160")
    }

    @Test
    func `Numeric: Invalid length`() {
        #expect(throws: ISO_15924.Numeric.Error.invalidCodeLength(2)) {
            try ISO_15924.Numeric("21")
        }

        #expect(throws: ISO_15924.Numeric.Error.invalidCodeLength(4)) {
            try ISO_15924.Numeric("2150")
        }

        #expect(throws: ISO_15924.Numeric.Error.invalidCodeLength(0)) {
            try ISO_15924.Numeric("")
        }
    }

    @Test
    func `Numeric: Invalid characters`() {
        #expect(throws: ISO_15924.Numeric.Error.invalidCharacters("21a")) {
            try ISO_15924.Numeric("21a")
        }

        #expect(throws: ISO_15924.Numeric.Error.invalidCharacters("21-")) {
            try ISO_15924.Numeric("21-")
        }

        #expect(throws: ISO_15924.Numeric.Error.invalidCharacters("21 ")) {
            try ISO_15924.Numeric("21 ")
        }
    }

    @Test
    func `Numeric: Unrecognized code`() {
        // Note: 999 is actually valid (Code for uncoded script - Zzzz)
        #expect(throws: ISO_15924.Numeric.Error.invalidNumericCode("001")) {
            try ISO_15924.Numeric("001")
        }

        #expect(throws: ISO_15924.Numeric.Error.invalidNumericCode("000")) {
            try ISO_15924.Numeric("000")
        }
    }

    @Test
    func `Numeric: Common static constants`() {
        #expect(ISO_15924.Numeric.`215`.value == "215")  // Latin
        #expect(ISO_15924.Numeric.`220`.value == "220")  // Cyrillic
        #expect(ISO_15924.Numeric.`160`.value == "160")  // Arabic
        #expect(ISO_15924.Numeric.`501`.value == "501")  // Han (Simplified)
        #expect(ISO_15924.Numeric.`502`.value == "502")  // Han (Traditional)
        #expect(ISO_15924.Numeric.`125`.value == "125")  // Hebrew
        #expect(ISO_15924.Numeric.`315`.value == "315")  // Devanagari
        #expect(ISO_15924.Numeric.`413`.value == "413")  // Japanese
    }

    @Test
    func `Numeric: String conversion`() {
        #expect(ISO_15924.Numeric.`215`.description == "215")
        #expect(String(describing: ISO_15924.Numeric.`220`) == "220")
    }

    @Test
    func `Numeric: Equality and hashing`() {
        let latin1 = ISO_15924.Numeric.`215`
        let latin2 = ISO_15924.Numeric.`215`
        #expect(latin1 == latin2)
        #expect(latin1.hashValue == latin2.hashValue)

        let cyrillic = ISO_15924.Numeric.`220`
        #expect(latin1 != cyrillic)
    }

    @Test
    func `Numeric: Codable round-trip`() throws {
        let original = ISO_15924.Numeric.`215`
        let encoder = JSONEncoder()
        let data = try encoder.encode(original)
        let decoder = JSONDecoder()
        let decoded = try decoder.decode(ISO_15924.Numeric.self, from: data)
        #expect(decoded == original)
        #expect(decoded.value == "215")
    }

    // MARK: - Conversion Tests

    @Test
    func `Conversion: Alpha4 to Numeric (total function)`() {
        let latin = ISO_15924.Alpha4.Latn
        let num215 = ISO_15924.Numeric(latin)
        #expect(num215.value == "215")

        let cyrillic = ISO_15924.Alpha4.Cyrl
        let num220 = ISO_15924.Numeric(cyrillic)
        #expect(num220.value == "220")
    }

    @Test
    func `Conversion: Numeric to Alpha4 (total function)`() {
        let num215 = ISO_15924.Numeric.`215`
        let latin = ISO_15924.Alpha4(num215)
        #expect(latin.value == "Latn")

        let num220 = ISO_15924.Numeric.`220`
        let cyrillic = ISO_15924.Alpha4(num220)
        #expect(cyrillic.value == "Cyrl")
    }

    @Test
    func `Conversion: Round-trip Alpha4 → Numeric → Alpha4`() {
        let original = ISO_15924.Alpha4.Latn
        let numeric = ISO_15924.Numeric(original)
        let roundtrip = ISO_15924.Alpha4(numeric)
        #expect(roundtrip == original)
    }

    // MARK: - CaseIterable Tests

    @Test
    func `CaseIterable: Alpha4 has all 226 codes`() {
        #expect(ISO_15924.Alpha4.allCases.count == 226)
        #expect(ISO_15924.Alpha4.allCases.contains(.Latn))
        #expect(ISO_15924.Alpha4.allCases.contains(.Cyrl))
    }

    @Test
    func `CaseIterable: Numeric has all 226 codes`() {
        #expect(ISO_15924.Numeric.allCases.count == 226)
        #expect(ISO_15924.Numeric.allCases.contains(.`215`))
        #expect(ISO_15924.Numeric.allCases.contains(.`220`))
    }

    // MARK: - Specific Scripts

    @Test
    func `ISO 15924: Major scripts`() throws {
        // Latin
        let latin = try ISO_15924.Alpha4("Latn")
        let latinNum = ISO_15924.Numeric(latin)
        #expect(latinNum.value == "215")

        // Cyrillic
        let cyrillic = try ISO_15924.Alpha4("Cyrl")
        let cyrillicNum = ISO_15924.Numeric(cyrillic)
        #expect(cyrillicNum.value == "220")

        // Arabic
        let arabic = try ISO_15924.Alpha4("Arab")
        let arabicNum = ISO_15924.Numeric(arabic)
        #expect(arabicNum.value == "160")

        // Han (Simplified)
        let hansimplified = try ISO_15924.Alpha4("Hans")
        let hanSimplifiedNum = ISO_15924.Numeric(hansimplified)
        #expect(hanSimplifiedNum.value == "501")

        // Han (Traditional)
        let hanTraditional = try ISO_15924.Alpha4("Hant")
        let hanTraditionalNum = ISO_15924.Numeric(hanTraditional)
        #expect(hanTraditionalNum.value == "502")
    }

    @Test
    func `ISO 15924: Asian scripts`() throws {
        // Japanese
        let japanese = try ISO_15924.Alpha4("Jpan")
        let japaneseNum = ISO_15924.Numeric(japanese)
        #expect(japaneseNum.value == "413")

        // Korean
        let korean = try ISO_15924.Alpha4("Kore")
        let koreanNum = ISO_15924.Numeric(korean)
        #expect(koreanNum.value == "287")

        // Devanagari (Hindi, Sanskrit)
        let devanagari = try ISO_15924.Alpha4("Deva")
        let devanagariNum = ISO_15924.Numeric(devanagari)
        #expect(devanagariNum.value == "315")

        // Thai
        let thai = try ISO_15924.Alpha4("Thai")
        let thaiNum = ISO_15924.Numeric(thai)
        #expect(thaiNum.value == "352")
    }

    @Test
    func `ISO 15924: Historical and special scripts`() throws {
        // Egyptian hieroglyphs
        let egyptian = try ISO_15924.Alpha4("Egyp")
        let egyptianNum = ISO_15924.Numeric(egyptian)
        #expect(egyptianNum.value == "050")

        // Braille
        let braille = try ISO_15924.Alpha4("Brai")
        let brailleNum = ISO_15924.Numeric(braille)
        #expect(brailleNum.value == "570")

        // Mathematical notation
        let math = try ISO_15924.Alpha4("Zmth")
        let mathNum = ISO_15924.Numeric(math)
        #expect(mathNum.value == "995")
    }
}
