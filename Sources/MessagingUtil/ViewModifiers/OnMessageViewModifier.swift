import SwiftUI

public typealias Handler<MessageContent> = (MessageContent, MessageInfo) -> (ProcessingAction, MessageContent?)

struct OnMessageViewModifier <MessageContent>: ViewModifier where MessageContent: Equatable {
    @EnvironmentObject private var messageReference: Reference<Message<MessageContent>?>

    @State private var previousId: UUID?

    let handler: Handler<MessageContent>

    func body (content: Content) -> some View {
        content
            .onChange(of: messageReference.referencedValue) { _ in
                handle()
            }
            .onAppear {
                handle()
            }
    }

    func handle () {
        guard
            let message = messageReference.referencedValue,
            message.status != .completed,
            message.id != previousId
        else { return }

        previousId = message.id

        let (processingAction, messageContent) = handler(message.content, message.info)

        messageReference.referencedValue = .init(
            id: message.id,
            status: processingAction.messageStatus,
            content: messageContent ?? message.content
        )
    }
}

public extension View {
    func onMessage <MessageContent> (
        of _: MessageContent.Type = MessageContent.self,
        perform action: @escaping Handler<MessageContent>
    ) -> some View where MessageContent: Equatable {
        modifier(
            OnMessageViewModifier<MessageContent>(handler: action)
        )
    }

    func onMessage <MessageContent> (
        of _: MessageContent.Type = MessageContent.self,
        perform action: @escaping (MessageContent, MessageInfo) -> ProcessingAction
    ) -> some View where MessageContent: Equatable {
        modifier(
            OnMessageViewModifier<MessageContent> {
                let processingAction = action($0, $1)
                return (processingAction, $0)
            }
        )
    }

    func onMessage <MessageContent> (
        of _: MessageContent.Type = MessageContent.self,
        perform action: @escaping (MessageContent, MessageInfo) -> Void
    ) -> some View where MessageContent: Equatable {
        modifier(
            OnMessageViewModifier<MessageContent> {
                action($0, $1)
                return (.complete, $0)
            }
        )
    }

    func onMessage <MessageContent> (
        of _: MessageContent.Type = MessageContent.self,
        perform action: @escaping (MessageContent) -> (ProcessingAction, MessageContent)
    ) -> some View where MessageContent: Equatable {
        modifier(
            OnMessageViewModifier<MessageContent> { messageContent, _ in
                action(messageContent)
            }
        )
    }

    func onMessage <MessageContent> (
        of _: MessageContent.Type = MessageContent.self,
        perform action: @escaping (MessageContent) -> ProcessingAction
    ) -> some View where MessageContent: Equatable {
        modifier(
            OnMessageViewModifier<MessageContent> { messageContent, _ in
                let processingAction = action(messageContent)
                return (processingAction, nil)
            }
        )
    }

    func onMessage <MessageContent> (
        of _: MessageContent.Type = MessageContent.self,
        perform action: @escaping (MessageContent) -> Void
    ) -> some View where MessageContent: Equatable {
        modifier(
            OnMessageViewModifier<MessageContent> { messageContent, _ in
                action(messageContent)
                return (.complete, nil)
            }
        )
    }
}
