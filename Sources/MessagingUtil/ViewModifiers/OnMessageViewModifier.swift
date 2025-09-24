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
            .onChange(of: messageReference.referencedValue) {
                handle($0)
            }
            .onAppear {
                handle()
            }
    }

    private func handle () {
        handle(messageReference.referencedValue)
    }

    private func handle (_ message: Message<MessagePayload>?) {
        guard let message = message else {
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

        lastReceivedMessageId = message.id

        let processingMessage = message.setStatus(.processing)
        messageReference.referencedValue = processingMessage

        logger.log(
            .info,
            "Message handling started",
            processingMessage,
            minLevel: minLogLevel
        )

        Task {
            let (processingAction, messagePayload) = await handle(message)

            let handledMessage = Message<MessagePayload>(
                id: message.id,
                status: processingAction.messageStatus,
                payload: messagePayload
            )

            messageReference.referencedValue = handledMessage

            logger.log(
                .info,
                "Handled message",
                handledMessage,
                minLevel: minLogLevel
            )
        }
    }

    private func handle (_ message: Message<MessagePayload>) async -> (ProcessingAction, MessagePayload) {
        do {
            return try await handler(message)
        } catch {
            return (.fail(error), message.payload)
        }
    }
}
