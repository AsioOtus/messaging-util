import Combine
import SwiftUI

struct MessageBroadcastViewModifier <MessagePayload, PayloadPublisher>: ViewModifier
where
MessagePayload: Sendable,
PayloadPublisher: Publisher<MessagePayload, Never>
{
    private let logger: Logger
    @Environment(\.messagingLogLevel) private var minLogLevel: LogLevel

    private let eventCompletionHandler: (Message<MessagePayload>, Error?) -> Void
    private let payloadPublisher: PayloadPublisher
    
    @StateObject private var message: Reference<Message<MessagePayload>?> = .init(nil)

    init (
        payloadPublisher: PayloadPublisher,
        fileId: String,
        line: Int,
        eventCompletionHandler: @escaping (Message<MessagePayload>, Error?) -> Void
    ) {
        self.eventCompletionHandler = eventCompletionHandler
        self.payloadPublisher = payloadPublisher
        self.logger = .init(name: "messageProvider", fileId: fileId, line: line)
    }

    func body (content: Content) -> some View {
        content
            .onReceive(payloadPublisher, perform: onNewMessage(payload:))
            .onChange(of: message.referencedValue, perform: onMessageChanged)
            .environmentObject(message)
    }

    private func onNewMessage (payload: MessagePayload) {
        let newId = String(UUID().uuidString.prefix(8))
        let message = Message(id: newId, status: .dispatching, payload: payload)

        handleNewMessage(message)
    }

    private func handleNewMessage (_ message: Message<MessagePayload>) {
        logger.log(
            .trace,
            "New message",
            message,
            minLevel: minLogLevel
        )

        if !message.status.isCompleted {
            logger.log(
                .trace,
                "Current message interrupted",
                self.message.referencedValue,
                minLevel: minLogLevel
            )

            self.message.referencedValue = self.message.referencedValue?.setStatus(.completed(InterruptedError()))
        }

        self.message.referencedValue = message
    }

    private func onMessageChanged (_ message: Message<MessagePayload>?) {
        if let message, message.status.isCompleted {
            logger.log(
                .trace,
                "Message completed",
                message,
                minLevel: minLogLevel
            )

            eventCompletionHandler(message, message.status.error)
        }
    }
}

public extension View {
    func messageBroadcast <MessagePayload, MessagePayloadPublisher> (
        _ payloadPublisher: MessagePayloadPublisher,
        fileId: String = #fileID,
        line: Int = #line,
        onEventCompletion: @escaping (Message<MessagePayload>, Error?) -> Void = { _, _ in }
    ) -> some View
    where
    MessagePayload: Sendable,
    MessagePayloadPublisher: Publisher<MessagePayload, Never>
    {
        modifier(
            MessageBroadcastViewModifier<MessagePayload, MessagePayloadPublisher>(
                payloadPublisher: payloadPublisher,
                fileId: fileId,
                line: line,
                eventCompletionHandler: onEventCompletion
            )
        )
    }
}
