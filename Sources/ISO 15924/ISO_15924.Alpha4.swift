import ASCII
import Standard_Library_Extensions

extension ISO_15924 {

    public struct Alpha4: Sendable, Equatable, Hashable {

        public let value: String

        public init(_ value: some StringProtocol) throws(Error) {

            let normalized = String(value.prefix(1).uppercased() + value.dropFirst().lowercased())

            guard normalized.count == 4 else {
                throw Alpha4.Error.invalidCodeLength(normalized.count)
            }

            guard normalized.allSatisfy({ $0.ascii.isLetter }) else {
                throw Alpha4.Error.invalidCharacters(normalized)
            }

            guard Self.validCodes.contains(normalized) else {
                throw Alpha4.Error.invalidAlpha4Code(normalized)
            }

            self.value = normalized
        }
    }
}

extension ISO_15924.Alpha4 {

    internal init(unchecked value: String) {
        self.value = value
    }

    internal static let validCodes: Set<String> = {
        Set(allCases.map { $0.value })
    }()
}

extension ISO_15924.Alpha4: CustomStringConvertible {
    public var description: String { value }
}

extension ISO_15924.Alpha4: Codable {
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

extension ISO_15924.Alpha4 {

    public init(_ numeric: ISO_15924.Numeric) {

        let alpha4 = ISO_15924.numericToAlpha4[numeric]!
        self = alpha4
    }
}
