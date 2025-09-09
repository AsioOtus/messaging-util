import SwiftUI

struct OnMessageViewModifier <MessagePayload>: ViewModifier where MessagePayload: Equatable {
    private let logger: Logger
    @Environment(\.messagingLogLevel) private var minLogLevel: LogLevel

    @EnvironmentObject private var messageReference: Reference<Message<MessagePayload>?>
    @State private var previousId: String?
    private let allowedValues: [MessagePayload]?
    private let handler: MessageHandler<MessagePayload>

    init (
        allowedValues: [MessagePayload]? = nil,
        fileId: String,
        line: Int,
        handler: @escaping MessageHandler<MessagePayload>
    ) {
        self.allowedValues = allowedValues
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

        if message.status == .processing {
            logger.log(
                .notice,
                "Processing message – \(message.id) – \(String(describing: message.payload))",
                minLevel: minLogLevel
            )
            return
        }

        if message.id == previousId {
            logger.log(
                .debug,
                "Duplicated message – \(message.id) – \(String(describing: message.payload))",
                minLevel: minLogLevel
            )
            return
        }

        if message.status == .completed {
            logger.log(
                .debug,
                "Completed message – \(message.id) – \(String(describing: message.payload))",
                minLevel: minLogLevel
            )
            return
        }

        if let allowedValues, !allowedValues.contains(message.payload) {
            logger.log(
                .trace,
                "Filtered message – \(message.id) – \(String(describing: message.payload))",
                minLevel: minLogLevel
            )
            return
        }

        handler(message) { processingAction, messagePayload in
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

        messageReference.referencedValue = message.setStatus(.processing)
        previousId = message.id
    }
}
