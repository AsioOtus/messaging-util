import SwiftUI

struct OnMessageViewModifier <MessageContent>: ViewModifier where MessageContent: Equatable {
    private let logger: Logger
    @Environment(\.messagingLogLevel) private var minLogLevel: LogLevel

    @EnvironmentObject private var messageReference: Reference<Message<MessageContent>?>
    @State private var previousId: String?
    private let allowedValues: [MessageContent]?
    private let handler: MessageHandler<MessageContent>

    init (
        allowedValues: [MessageContent]? = nil,
        fileId: String,
        line: Int,
        handler: @escaping MessageHandler<MessageContent>
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
                "Processing message – \(message.id) – \(String(describing: message.content))",
                minLevel: minLogLevel
            )
            return
        }

        if message.id == previousId {
            logger.log(
                .debug,
                "Duplicated message – \(message.id) – \(String(describing: message.content))",
                minLevel: minLogLevel
            )
            return
        }

        if message.status == .completed {
            logger.log(
                .debug,
                "Completed message – \(message.id) – \(String(describing: message.content))",
                minLevel: minLogLevel
            )
            return
        }

        if let allowedValues, !allowedValues.contains(message.content) {
            logger.log(
                .trace,
                "Filtered message – \(message.id) – \(String(describing: message.content))",
                minLevel: minLogLevel
            )
            return
        }

        handler(message) { processingAction, messageContent in
            logger.log(
                .info,
                "Handled message – \(message.id) – \(String(describing: messageContent)) – \(processingAction)",
                minLevel: minLogLevel
            )

            messageReference.referencedValue = .init(
                id: message.id,
                status: processingAction.messageStatus,
                content: messageContent
            )
        }

        messageReference.referencedValue = message.setStatus(.processing)
        previousId = message.id
    }
}
