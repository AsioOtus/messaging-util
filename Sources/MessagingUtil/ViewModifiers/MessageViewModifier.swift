import SwiftUI

struct MessageViewModifier <MC>: ViewModifier where MC: Equatable {
    let message: Message<MC>?

    @StateObject private var descendingMessage: Reference<Message<MC>?> = .init(nil)

    init (messageContent: MC?) {
        self.message = messageContent.map { .init(id: .init(), status: .unhandled, content: $0) }
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
    func message <MC> (
        _ content: MC?
    ) -> some View where MC: Equatable {
        modifier(MessageViewModifier<MC>(messageContent: content))
    }
}
