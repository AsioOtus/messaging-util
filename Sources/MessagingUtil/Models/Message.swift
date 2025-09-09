public struct Message <Payload: Equatable>: Equatable {
    public let id: String
    public let status: MessageStatus
    public let payload: Payload
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
