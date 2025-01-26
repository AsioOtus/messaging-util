import Foundation

public struct Message <Content: Equatable>: Equatable {
    let id: UUID
    let status: MessageStatus
    let content: Content

    func setStatus (_ status: MessageStatus) -> Self {
        .init(
            id: id,
            status: status,
            content: content
        )
    }

    func envelope (_ content: Content) -> MessageEnvelope<Content> {
        .init(id: id, status: status, content: content)
    }
}
