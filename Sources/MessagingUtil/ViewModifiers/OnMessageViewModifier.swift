import SwiftUI

public typealias Handler<MessageContent> = (MessageEnvelope<MessageContent>) -> (ProcessingAction, MessageContent)

struct OnMessageViewModifier <MessageContent>: ViewModifier where MessageContent: Equatable {
    @EnvironmentObject private var messageReference: Reference<Message<MessageContent>?>

    let handler: Handler<MessageContent>

    func body (content: Content) -> some View {
        content
            .onChange(of: messageReference.referencedValue) { _ in
                guard
                    let message = messageReference.referencedValue,
                    message.status != .completed
                else { return }

                let (processingAction, messageContent) = handler(message.envelope(message.content))

                messageReference.referencedValue = .init(
                    id: message.id,
                    status: processingAction.messageStatus,
                    content: messageContent
                )
            }
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
        perform action: @escaping (MessageEnvelope<MessageContent>) -> ProcessingAction
    ) -> some View where MessageContent: Equatable {
        modifier(
            OnMessageViewModifier<MessageContent> {
                let processingAction = action($0)
                return (processingAction, $0.content)
            }
        )
    }

    func onMessage <MessageContent> (
        of _: MessageContent.Type = MessageContent.self,
        perform action: @escaping (MessageEnvelope<MessageContent>) -> Void
    ) -> some View where MessageContent: Equatable {
        modifier(
            OnMessageViewModifier<MessageContent> {
                action($0)
                return (.complete, $0.content)
            }
        )
    }
}
