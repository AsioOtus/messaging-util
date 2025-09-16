public struct Message <Payload>: Equatable, Sendable where Payload: Sendable {
    public let id: String
    public let status: MessageStatus
    public let payload: Payload

    public static func == (_ lhs: Self, _ rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}

extension Message: CustomStringConvertible {
    public var description: String {
        "\(id) \(String(describing: payload)) \(status)"
    }
}

public extension Message {
    func setStatus (_ status: MessageStatus) -> Self {
        .init(
            id: id,
            status: status,
            payload: payload
        )
    }
}
