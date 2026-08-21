extension ISO_15924.Alpha4 {
    public enum Error: Swift.Error, Sendable, Equatable {

        case invalidCodeLength(Int)

        case invalidCharacters(String)

        case invalidAlpha4Code(String)
    }
}
