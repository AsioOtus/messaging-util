import SwiftUI

struct OnMessageViewModifier <MessageContent>: ViewModifier where MessageContent: Equatable {
    private let logger: Logger
    @Environment(\.messagingLogLevel) private var minLogLevel: LogLevel

    @EnvironmentObject private var messageReference: Reference<Message<MessageContent>?>
    @State private var previousId: String?
    private let allowedValues: [MessageContent]?
    private let handler: (Message<MessageContent>) -> (ProcessingAction, MessageContent)

    init (
        allowedValues: [MessageContent]? = nil,
        fileId: String,
        line: Int,
        handler: @escaping (Message<MessageContent>) -> (ProcessingAction, MessageContent)
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
        guard let message = messageReference.referencedValue
        else {
            logger.log(
                .notice,
                "nil message",
                minLevel: minLogLevel
            )
            return
        }

        guard message.id != previousId
        else {
            logger.log(
                .debug,
                "Duplicated message – \(message.id) – \(String(describing: message.content))",
                minLevel: minLogLevel
            )
            return
        }

        guard message.status != .processing
        else {
            logger.log(
                .debug,
                "Processing message – \(message.id) – \(String(describing: message.content))",
                minLevel: minLogLevel
            )
            return
        }

        guard message.status != .completed
        else {
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

        let (processingAction, messageContent) = handler(message)

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

        previousId = message.id
    }
}
