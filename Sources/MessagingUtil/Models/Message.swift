public struct Message <Content: Equatable>: Equatable {
    public let id: String
    public let status: MessageStatus
    public let content: Content
}

public extension Message {
    func setStatus (_ status: MessageStatus) -> Self {
        .init(
            id: id,
            status: status,
            content: content
        )
    }
}
