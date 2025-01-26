import SwiftUI

struct MessageViewModifier <MessageContent>: ViewModifier where MessageContent: Equatable {
    let message: Message<MessageContent>?

    @StateObject private var descendingMessage: Reference<Message<MessageContent>?> = .init(nil)

    init (messageContent: MessageContent?) {
        self.message = messageContent.map { .init(id: .init(), status: .unprocessed, content: $0) }
    }

    func body (content: Content) -> some View {
        content
            .onChange(of: message) { message in
                descendingMessage.referencedValue = message
            }
            .environmentObject(descendingMessage)
    }
}

public extension View {
    func message <MessageContent> (
        _ content: MessageContent?
    ) -> some View where MessageContent: Equatable {
        modifier(MessageViewModifier<MessageContent>(messageContent: content))
    }
}
