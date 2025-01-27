import Combine
import SwiftUI

struct MessageViewModifier <MessageContent, MessageContentPublisher>: ViewModifier
where MessageContent: Equatable, MessageContentPublisher: Publisher<MessageContent, Never> {
    let messageContentPublisher: MessageContentPublisher

    @StateObject private var descendingMessage: Reference<Message<MessageContent>?> = .init(nil)

    init (messageContentPublisher: MessageContentPublisher) {
        self.messageContentPublisher = messageContentPublisher
    }

    func body (content: Content) -> some View {
        content
            .onReceive(messageContentPublisher) { messageContent in
                descendingMessage.referencedValue = .init(id: .init(), status: .unprocessed, content: messageContent)
            }
            .environmentObject(descendingMessage)
    }
}

public extension View {
    func message <MessageContent, MessageContentPublisher> (
        _ contentPublisher: MessageContentPublisher
    ) -> some View where MessageContent: Equatable, MessageContentPublisher: Publisher<MessageContent, Never> {
        modifier(
            MessageViewModifier<MessageContent, MessageContentPublisher>(
                messageContentPublisher: contentPublisher
            )
        )
    }
}
