import Combine
import SwiftUI

struct MessageProviderViewModifier <MessageContent, ContentPublisher>: ViewModifier
where MessageContent: Equatable, ContentPublisher: Publisher<MessageContent, Never> {
    private let logger: Logger
    @Environment(\.messagingLogLevel) private var minLogLevel: LogLevel

    private let contentPublisher: ContentPublisher
    @StateObject private var message: Reference<Message<MessageContent>?> = .init(nil)

    @StateObject private var messageBuffer: Buffer<Message<MessageContent>>

    init (
        contentPublisher: ContentPublisher,
        bufferSize: Int?,
        fileId: String,
        line: Int
    ) {
        self.contentPublisher = contentPublisher
        self._messageBuffer = .init(wrappedValue: .init(bufferSize: bufferSize))
        self.logger = .init(name: "messageProvider", fileId: fileId, line: line)
    }

    func body (content: Content) -> some View {
        content
            .onReceive(contentPublisher, perform: onNewMessage(content:))
            .onChange(of: message.referencedValue) { _ in handleNextMessage() }
            .environmentObject(message)
    }

    private func onNewMessage (content: MessageContent) {
        let newId = String(UUID().uuidString.prefix(8))
        let message = Message(id: newId, status: .unprocessed, content: content)

        logger.log(
            .trace,
            "New message – \(message.id) – \(String(describing: content))",
            minLevel: minLogLevel
        )

        messageBuffer.add(message)
        handleNextMessage()
    }

    private func handleNextMessage () {
        guard message.referencedValue?.status == .completed else { return }
        self.message.referencedValue = messageBuffer.next()
    }
}

public extension View {
    func messageProvider <MessageContent, MessageContentPublisher> (
        _ contentPublisher: MessageContentPublisher,
        bufferSize: Int? = nil,
        fileId: String = #fileID,
        line: Int = #line
    ) -> some View where MessageContent: Equatable, MessageContentPublisher: Publisher<MessageContent, Never> {
        modifier(
            MessageProviderViewModifier<MessageContent, MessageContentPublisher>(
                contentPublisher: contentPublisher,
                bufferSize: bufferSize,
                fileId: fileId,
                line: line
            )
        )
    }
}
