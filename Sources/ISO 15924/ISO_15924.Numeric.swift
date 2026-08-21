import ASCII_Primitives
import Standard_Library_Extensions

extension ISO_15924 {

    public struct Numeric: Sendable, Equatable, Hashable {

        public let value: String

        public init(_ value: some StringProtocol) throws(Error) {
            let normalized = String(value)

            guard normalized.count == 3 else {
                throw Numeric.Error.invalidCodeLength(normalized.count)
            }

            guard normalized.allSatisfy({ $0.ascii.isDigit }) else {
                throw Numeric.Error.invalidCharacters(normalized)
            }

            guard Self.validCodes.contains(normalized) else {
                throw Numeric.Error.invalidNumericCode(normalized)
            }

            self.value = normalized
        }
    }
}

extension ISO_15924.Numeric {

    internal init(unchecked value: String) {
        self.value = value
    }

    internal static let validCodes: Set<String> = {
        Set(allCases.map { $0.value })
    }()
}

extension ISO_15924.Numeric: CustomStringConvertible {
    public var description: String { value }
}

extension ISO_15924.Numeric: Codable {
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(value)
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        try self.init(string)
    }
}

extension ISO_15924.Numeric {

    public init(_ alpha4: ISO_15924.Alpha4) {

        let numeric = ISO_15924.alpha4ToNumeric[alpha4]!
        self = numeric
    }
}
