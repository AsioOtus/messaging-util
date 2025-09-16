import SwiftUI

struct OnMessageViewModifier <MessagePayload>: ViewModifier where MessagePayload: Sendable {
    private let logger: Logger
    @Environment(\.messagingLogLevel) private var minLogLevel: LogLevel

    @EnvironmentObject private var messageReference: Reference<Message<MessagePayload>?>
    @State private var lastReceivedMessageId: String?
    private let handler: MessageHandler<MessagePayload>

    init (
        fileId: String,
        line: Int,
        handler: @escaping MessageHandler<MessagePayload>
    ) {
        self.handler = handler
        self.logger = .init(name: "onMessage", fileId: fileId, line: line)
    }

    func body (content: Content) -> some View {
        content
            .onChange(of: messageReference.referencedValue) { _ in
                handle()
            }
            .onAppear {
                handle()
            }
    }

    private func handle () {
        guard let message = messageReference.referencedValue else {
            logger.log(
                .notice,
                "nil message",
                Message<MessagePayload>?.none,
                minLevel: minLogLevel
            )
            return
        }

        if message.id == lastReceivedMessageId {
            logger.log(
                .notice,
                "Duplicated message",
                message,
                minLevel: minLogLevel
            )
            return
        }

        lastReceivedMessageId = message.id

        if message.status.isProcessing {
            logger.log(
                .debug,
                "Processing message",
                message,
                minLevel: minLogLevel
            )
            return
        }

        if message.status.isCompleted {
            logger.log(
                .debug,
                "Completed message",
                message,
                minLevel: minLogLevel
            )
            return
        }

        messageReference.referencedValue = message.setStatus(.processing)

        Task {
            let (processingAction, messagePayload) = await handler(message)

            let logMessage = Message(
                id: message.id,
                status: message.status,
                payload: messagePayload
            )
            logger.log(
                .info,
                "Handled message – \(processingAction)",
                logMessage,
                minLevel: minLogLevel
            )

            messageReference.referencedValue = .init(
                id: message.id,
                status: processingAction.messageStatus,
                payload: messagePayload
            )
        }
    }
}
