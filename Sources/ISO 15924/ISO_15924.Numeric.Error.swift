extension ISO_15924.Numeric {
    public enum Error: Swift.Error, Sendable, Equatable {

        case invalidCodeLength(Int)

        case invalidCharacters(String)

        case invalidNumericCode(String)
    }
}
