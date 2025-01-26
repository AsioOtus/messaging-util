import Foundation

public struct MessageEnvelope <Content> {
    public let id: UUID
    public let status: MessageStatus
    public let content: Content
}
