import Standard_Library_Extensions

extension ISO_15924 {

    public enum Error: Swift.Error, Sendable, Equatable {

        case invalidCodeLength(Int)

        case invalidCharacters(String)

        case invalidAlpha4Code(String)

        case invalidNumericCode(String)
    }
}
