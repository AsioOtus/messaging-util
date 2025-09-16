import Combine
import SwiftUI

struct MessageBroadcastViewModifier <MessagePayload, PayloadPublisher>: ViewModifier
where
MessagePayload: Sendable,
PayloadPublisher: Publisher<MessagePayload, Never>
{
    private let logger: Logger
    @Environment(\.messagingLogLevel) private var minLogLevel: LogLevel

    private let completionHandler: (Message<MessagePayload>, Error?) -> Void
    private let payloadPublisher: PayloadPublisher
    
    @StateObject private var message: Reference<Message<MessagePayload>?> = .init(nil)
    @StateObject private var messageBuffer: Buffer<Message<MessagePayload>>

    init (
        payloadPublisher: PayloadPublisher,
        bufferSize: Int?,
        fileId: String,
        line: Int,
        completionHandler: @escaping (Message<MessagePayload>, Error?) -> Void
    ) {
        self.completionHandler = completionHandler
        self.payloadPublisher = payloadPublisher
        self._messageBuffer = .init(wrappedValue: .init(bufferSize: bufferSize))
        self.logger = .init(name: "messageProvider", fileId: fileId, line: line)
    }

    func body (content: Content) -> some View {
        content
            .onReceive(payloadPublisher, perform: onNewMessage(payload:))
            .onChange(of: message.referencedValue) { _ in handleNextMessage() }
            .environmentObject(message)
    }

    private func onNewMessage (payload: MessagePayload) {
        let newId = String(UUID().uuidString.prefix(8))
        let message = Message(id: newId, status: .dispatching, payload: payload)

        logger.log(
            .trace,
            "New message",
            message,
            minLevel: minLogLevel
        )

        messageBuffer.add(message)
        handleNextMessage()
    }

    private func handleNextMessage () {
        guard
            message.referencedValue == nil ||
            message.referencedValue?.status.isCompleted == true
        else { return }

        if
            let message = message.referencedValue,
            case .completed(let error) = message.status
        {
            completionHandler(message, error)
        }

        message.referencedValue = messageBuffer.next()
    }
}

public extension View {
    func messageBroadcast <MessagePayload, MessagePayloadPublisher> (
        _ payloadPublisher: MessagePayloadPublisher,
        bufferSize: Int? = nil,
        fileId: String = #fileID,
        line: Int = #line,
        onCompletion: @escaping (Message<MessagePayload>, Error?) -> Void = { _, _ in }
    ) -> some View
    where
    MessagePayload: Sendable,
    MessagePayloadPublisher: Publisher<MessagePayload, Never>
    {
        modifier(
            MessageBroadcastViewModifier<MessagePayload, MessagePayloadPublisher>(
                payloadPublisher: payloadPublisher,
                bufferSize: bufferSize,
                fileId: fileId,
                line: line,
                completionHandler: onCompletion
            )
        )
    }
}
