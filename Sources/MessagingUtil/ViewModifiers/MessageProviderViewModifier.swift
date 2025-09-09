import Combine
import SwiftUI

struct MessageProviderViewModifier <MessagePayload, PayloadPublisher>: ViewModifier
where MessagePayload: Equatable, PayloadPublisher: Publisher<MessagePayload, Never> {
    private let logger: Logger
    @Environment(\.messagingLogLevel) private var minLogLevel: LogLevel

    private let payloadPublisher: PayloadPublisher
    @StateObject private var message: Reference<Message<MessagePayload>?> = .init(nil)

    @StateObject private var messageBuffer: Buffer<Message<MessagePayload>>

    init (
        payloadPublisher: PayloadPublisher,
        bufferSize: Int?,
        fileId: String,
        line: Int
    ) {
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
            "New message – \(message.id) – \(String(describing: payload))",
            minLevel: minLogLevel
        )

        messageBuffer.add(message)
        handleNextMessage()
    }

    private func handleNextMessage () {
        guard
            message.referencedValue == nil ||
            message.referencedValue?.status == .completed
        else { return }

        self.message.referencedValue = messageBuffer.next()
    }
}

public extension View {
    func messageProvider <MessagePayload, MessagePayloadPublisher> (
        _ payloadPublisher: MessagePayloadPublisher,
        bufferSize: Int? = nil,
        fileId: String = #fileID,
        line: Int = #line
    ) -> some View where MessagePayload: Equatable, MessagePayloadPublisher: Publisher<MessagePayload, Never> {
        modifier(
            MessageProviderViewModifier<MessagePayload, MessagePayloadPublisher>(
                payloadPublisher: payloadPublisher,
                bufferSize: bufferSize,
                fileId: fileId,
                line: line
            )
        )
    }
}
