public struct Signal <Payload>: Equatable, Sendable where Payload: Sendable, Payload: Equatable {
    public let id: String
    public let status: SignalStatus
    public let payload: Payload
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
