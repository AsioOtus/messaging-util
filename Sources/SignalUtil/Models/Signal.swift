public struct Signal <Payload>: Equatable, Sendable where Payload: Sendable {
    public let id: String
    public let status: SignalStatus
    public let payload: Payload

    public static func == (_ lhs: Self, _ rhs: Self) -> Bool {
        lhs.id == rhs.id && lhs.status == rhs.status
    }
}

extension Signal: CustomStringConvertible {
    public var description: String {
        "\(id) – \(String(describing: payload)) – \(status)"
    }
}

public extension Signal {
    func setStatus (_ status: SignalStatus) -> Self {
        .init(
            id: id,
            status: status,
            payload: payload
        )
    }
}
