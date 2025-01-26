import SwiftUI

struct OnMessageViewModifier <MC: Equatable>: ViewModifier {
    @EnvironmentObject private var messageReference: Reference<Message<MC>?>

    let handler: (MessageEnvelope<MC>) -> MessageStatus

    func body (content: Content) -> some View {
        content
            .onChange(of: messageReference.referencedValue) { _ in
                guard
                    let message = messageReference.referencedValue,
                    message.status != .completed
                else { return }

                let status = handler(message.envelope(message.content))
                messageReference.referencedValue = message.setStatus(status)
            }
    }
}

public extension View {
    func onMessage <MC: Equatable> (
        of content: MC.Type = MC.self,
        perform action: @escaping (MessageEnvelope<MC>) -> MessageStatus
    ) -> some View {
        modifier(
            OnMessageViewModifier<MC>(handler: action)
        )
    }

    func onMessage <MC: Equatable> (
        of content: MC.Type = MC.self,
        equalTo message: MC,
        perform action: @escaping (MessageEnvelope<MC>) -> MessageStatus
    ) -> some View {
        modifier(
            OnMessageViewModifier<MC> {
                if $0.content == message {
                    action($0)
                } else {
                    .unhandled
                }
            }
        )
    }

    func onMessage <MC: Equatable> (
        of content: MC.Type = MC.self,
        where condition: @escaping (MC) -> Bool,
        perform action: @escaping (MessageEnvelope<MC>) -> MessageStatus
    ) -> some View {
        modifier(
            OnMessageViewModifier<MC> {
                if condition($0.content) {
                    action($0)
                } else {
                    .unhandled
                }
            }
        )
    }

    func onMessage <MC: Equatable> (
        of content: MC.Type = MC.self,
        perform action: @escaping (MessageEnvelope<MC>) -> Void
    ) -> some View {
        modifier(
            OnMessageViewModifier<MC> {
                action($0)
                return .completed
            }
        )
    }

    func onMessage <MC: Equatable> (
        of content: MC.Type = MC.self,
        equalTo message: MC,
        perform action: @escaping (MessageEnvelope<MC>) -> Void
    ) -> some View {
        modifier(
            OnMessageViewModifier<MC> {
                if $0.content == message {
                    action($0)
                    return .completed
                } else {
                    return .unhandled
                }
            }
        )
    }

    func onMessage <MC: Equatable> (
        of content: MC.Type = MC.self,
        where condition: @escaping (MC) -> Bool,
        perform action: @escaping (MessageEnvelope<MC>) -> Void
    ) -> some View {
        modifier(
            OnMessageViewModifier<MC> {
                if condition($0.content) {
                    action($0)
                    return .completed
                } else {
                    return .unhandled
                }
            }
        )
    }
}
