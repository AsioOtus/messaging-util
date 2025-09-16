import SwiftUI

struct OnMessageViewModifier <MessagePayload>: ViewModifier where MessagePayload: Sendable {
    private let logger: Logger
    @Environment(\.messagingLogLevel) private var minLogLevel: LogLevel

    @EnvironmentObject private var messageReference: Reference<Message<MessagePayload>?>
    @State private var previousId: String?
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
                minLevel: minLogLevel
            )
            return
        }

        if message.id == previousId {
            logger.log(
                .notice,
                "Duplicated message – \(message.id) – \(String(describing: message.payload))",
                minLevel: minLogLevel
            )
            return
        }

        previousId = message.id

        if message.status.isProcessing {
            logger.log(
                .debug,
                "Processing message – \(message.id) – \(String(describing: message.payload))",
                minLevel: minLogLevel
            )
            return
        }

        if message.status.isCompleted {
            logger.log(
                .debug,
                "Completed message – \(message.id) – \(String(describing: message.payload))",
                minLevel: minLogLevel
            )
            return
        }

        messageReference.referencedValue = message.setStatus(.processing)

        Task {
            let (processingAction, messagePayload) = await handler(message)

            logger.log(
                .info,
                "Handled message – \(message.id) – \(String(describing: messagePayload)) – \(processingAction)",
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
