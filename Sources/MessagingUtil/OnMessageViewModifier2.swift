import Combine
import SwiftUI

public class MessageSource<MessageContent: Equatable>: ObservableObject {
    typealias Output = Message<MessageContent>?
    typealias Failure = Never

    internal let subject = CurrentValueSubject<Message<MessageContent>?, Never>(nil)

    public init () { }

    public func send (_ content: MessageContent) {
        let newId = String(UUID().uuidString.prefix(8))
        let message = Message(id: newId, status: .unprocessed, content: content)
        subject.send(message)
    }
}

public extension View {
    func messageSource <MessageContent: Equatable> (_ subject: MessageSource<MessageContent>) -> some View {
        environmentObject(subject)
    }
}

struct OnMessageViewModifier2 <MessageContent>: ViewModifier where MessageContent: Equatable {
    private let logger: Logger
    @Environment(\.messagingLogLevel) private var minLogLevel: LogLevel
    
    @EnvironmentObject private var messageSource: MessageSource<MessageContent>
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

        self.logger = .init(name: "onMessage2", fileId: fileId, line: line)
    }

    func body (content: Content) -> some View {
        content
            .onReceive(messageSource.subject) { _ in
                handle()
            }
            .onAppear {
                handle()
            }
    }

    private func handle () {
        guard let message = messageSource.subject.value
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

        messageSource.subject.send(
            .init(
                id: message.id,
                status: processingAction.messageStatus,
                content: messageContent
            )
        )

        previousId = message.id
    }
}

public extension View {
    func onMessage2 <MessageContent> (
        of _: MessageContent.Type = MessageContent.self,
        fileId: String = #fileID,
        line: Int = #line,
        perform action: @escaping (Message<MessageContent>) -> (ProcessingAction, MessageContent)
    ) -> some View where MessageContent: Equatable {
        modifier(
            OnMessageViewModifier2<MessageContent>(
                fileId: fileId,
                line: line,
                handler: action
            )
        )
    }

    func onMessage2 <MessageContent> (
        of allowedValues: MessageContent...,
        fileId: String = #fileID,
        line: Int = #line,
        perform action: @escaping (Message<MessageContent>) -> (ProcessingAction, MessageContent)
    ) -> some View where MessageContent: Equatable {
        modifier(
            OnMessageViewModifier2<MessageContent>(
                allowedValues: allowedValues,
                fileId: fileId,
                line: line,
                handler: action
            )
        )
    }



    func onMessage2 <MessageContent> (
        of _: MessageContent.Type = MessageContent.self,
        fileId: String = #fileID,
        line: Int = #line,
        perform action: @escaping (Message<MessageContent>) -> ProcessingAction
    ) -> some View where MessageContent: Equatable {
        modifier(
            OnMessageViewModifier2<MessageContent>(
                fileId: fileId,
                line: line
            ) {
                let processingAction = action($0)
                return (processingAction, $0.content)
            }
        )
    }

    func onMessage2 <MessageContent> (
        of allowedValues: MessageContent...,
        fileId: String = #fileID,
        line: Int = #line,
        perform action: @escaping (Message<MessageContent>) -> ProcessingAction
    ) -> some View where MessageContent: Equatable {
        modifier(
            OnMessageViewModifier2<MessageContent>(
                allowedValues: allowedValues,
                fileId: fileId,
                line: line
            ) {
                let processingAction = action($0)
                return (processingAction, $0.content)
            }
        )
    }



    func onMessage2 <MessageContent> (
        of _: MessageContent.Type = MessageContent.self,
        fileId: String = #fileID,
        line: Int = #line,
        isCompleting: Bool = false,
        perform action: @escaping (Message<MessageContent>) -> MessageContent
    ) -> some View where MessageContent: Equatable {
        modifier(
            OnMessageViewModifier2<MessageContent>(
                fileId: fileId,
                line: line
            ) {
                let content = action($0)
                return (isCompleting ? .complete : .continue, content)
            }
        )
    }

    func onMessage2 <MessageContent> (
        of allowedValues: MessageContent...,
        fileId: String = #fileID,
        line: Int = #line,
        isCompleting: Bool = false,
        perform action: @escaping (Message<MessageContent>) -> MessageContent
    ) -> some View where MessageContent: Equatable {
        modifier(
            OnMessageViewModifier2<MessageContent>(
                allowedValues: allowedValues,
                fileId: fileId,
                line: line
            ) {
                let content = action($0)
                return (isCompleting ? .complete : .continue, content)
            }
        )
    }



    func onMessage2 <MessageContent> (
        of _: MessageContent.Type = MessageContent.self,
        isCompleting: Bool = false,
        fileId: String = #fileID,
        line: Int = #line,
        perform action: @escaping (Message<MessageContent>) -> Void
    ) -> some View where MessageContent: Equatable {
        modifier(
            OnMessageViewModifier2<MessageContent>(
                fileId: fileId,
                line: line
            ) {
                action($0)
                return (isCompleting ? .complete : .continue, $0.content)
            }
        )
    }

    func onMessage2 <MessageContent> (
        of allowedValues: MessageContent...,
        isCompleting: Bool = false,
        fileId: String = #fileID,
        line: Int = #line,
        perform action: @escaping (Message<MessageContent>) -> Void
    ) -> some View where MessageContent: Equatable {
        modifier(
            OnMessageViewModifier2<MessageContent>(
                allowedValues: allowedValues,
                fileId: fileId,
                line: line
            ) {
                action($0)
                return (isCompleting ? .complete : .continue, $0.content)
            }
        )
    }



    func onMessage2 <MessageContent> (
        of allowedValues: MessageContent...,
        isCompleting: Bool = false,
        fileId: String = #fileID,
        line: Int = #line,
        perform action: @escaping () -> Void
    ) -> some View where MessageContent: Equatable {
        modifier(
            OnMessageViewModifier2<MessageContent>(
                allowedValues: allowedValues,
                fileId: fileId,
                line: line
            ) {
                action()
                return (isCompleting ? .complete : .continue, $0.content)
            }
        )
    }
}
