import SwiftUI

// MARK: - Return (ProcessingAction, MessageContent)
public extension View {
    func onMessage <MessageContent> (
        of _: MessageContent.Type = MessageContent.self,
        fileId: String = #fileID,
        line: Int = #line,
        perform action: @escaping (Message<MessageContent>) -> (ProcessingAction, MessageContent)
    ) -> some View where MessageContent: Equatable {
        modifier(
            OnMessageViewModifier<MessageContent>(
                fileId: fileId,
                line: line,
                handler: action
            )
        )
    }

    func onMessage <MessageContent> (
        of allowedValues: MessageContent...,
        fileId: String = #fileID,
        line: Int = #line,
        perform action: @escaping (Message<MessageContent>) -> (ProcessingAction, MessageContent)
    ) -> some View where MessageContent: Equatable {
        modifier(
            OnMessageViewModifier<MessageContent>(
                allowedValues: allowedValues,
                fileId: fileId,
                line: line,
                handler: action
            )
        )
    }

    func onMessage <MessageContent> (
        of _: MessageContent.Type = MessageContent.self,
        fileId: String = #fileID,
        line: Int = #line,
        perform action: @escaping (MessageContent) -> (ProcessingAction, MessageContent)
    ) -> some View where MessageContent: Equatable {
        modifier(
            OnMessageViewModifier<MessageContent>(
                fileId: fileId,
                line: line
            ) {
                action($0.content)
            }
        )
    }

    func onMessage <MessageContent> (
        of allowedValues: MessageContent...,
        fileId: String = #fileID,
        line: Int = #line,
        perform action: @escaping (MessageContent) -> (ProcessingAction, MessageContent)
    ) -> some View where MessageContent: Equatable {
        modifier(
            OnMessageViewModifier<MessageContent>(
                allowedValues: allowedValues,
                fileId: fileId,
                line: line
            ) {
                action($0.content)
            }
        )
    }

    func onMessage <MessageContent> (
        of _: MessageContent.Type = MessageContent.self,
        fileId: String = #fileID,
        line: Int = #line,
        perform action: @escaping () -> (ProcessingAction, MessageContent)
    ) -> some View where MessageContent: Equatable {
        modifier(
            OnMessageViewModifier<MessageContent>(
                fileId: fileId,
                line: line
            ) { _ in
                action()
            }
        )
    }

    func onMessage <MessageContent> (
        of allowedValues: MessageContent...,
        fileId: String = #fileID,
        line: Int = #line,
        perform action: @escaping () -> (ProcessingAction, MessageContent)
    ) -> some View where MessageContent: Equatable {
        modifier(
            OnMessageViewModifier<MessageContent>(
                allowedValues: allowedValues,
                fileId: fileId,
                line: line
            ) { _ in
                action()
            }
        )
    }
}

// MARK: - Return ProcessingAction
public extension View {
    func onMessage <MessageContent> (
        of _: MessageContent.Type = MessageContent.self,
        fileId: String = #fileID,
        line: Int = #line,
        perform action: @escaping (Message<MessageContent>) -> ProcessingAction
    ) -> some View where MessageContent: Equatable {
        modifier(
            OnMessageViewModifier<MessageContent>(
                fileId: fileId,
                line: line
            ) {
                let processingAction = action($0)
                return (processingAction, $0.content)
            }
        )
    }

    func onMessage <MessageContent> (
        of allowedValues: MessageContent...,
        fileId: String = #fileID,
        line: Int = #line,
        perform action: @escaping (Message<MessageContent>) -> ProcessingAction
    ) -> some View where MessageContent: Equatable {
        modifier(
            OnMessageViewModifier<MessageContent>(
                allowedValues: allowedValues,
                fileId: fileId,
                line: line
            ) {
                let processingAction = action($0)
                return (processingAction, $0.content)
            }
        )
    }

    func onMessage <MessageContent> (
        of _: MessageContent.Type,
        fileId: String = #fileID,
        line: Int = #line,
        perform action: @escaping (MessageContent) -> ProcessingAction
    ) -> some View where MessageContent: Equatable {
        modifier(
            OnMessageViewModifier<MessageContent>(
                fileId: fileId,
                line: line
            ) {
                let processingAction = action($0.content)
                return (processingAction, $0.content)
            }
        )
    }

    func onMessage <MessageContent> (
        of allowedValues: MessageContent...,
        fileId: String = #fileID,
        line: Int = #line,
        perform action: @escaping (MessageContent) -> ProcessingAction
    ) -> some View where MessageContent: Equatable {
        modifier(
            OnMessageViewModifier<MessageContent>(
                allowedValues: allowedValues,
                fileId: fileId,
                line: line
            ) {
                let processingAction = action($0.content)
                return (processingAction, $0.content)
            }
        )
    }

    func onMessage <MessageContent> (
        of _: MessageContent.Type = MessageContent.self,
        fileId: String = #fileID,
        line: Int = #line,
        perform action: @escaping () -> ProcessingAction
    ) -> some View where MessageContent: Equatable {
        modifier(
            OnMessageViewModifier<MessageContent>(
                fileId: fileId,
                line: line
            ) {
                let processingAction = action()
                return (processingAction, $0.content)
            }
        )
    }

    func onMessage <MessageContent> (
        of allowedValues: MessageContent...,
        fileId: String = #fileID,
        line: Int = #line,
        perform action: @escaping () -> ProcessingAction
    ) -> some View where MessageContent: Equatable {
        modifier(
            OnMessageViewModifier<MessageContent>(
                allowedValues: allowedValues,
                fileId: fileId,
                line: line
            ) {
                let processingAction = action()
                return (processingAction, $0.content)
            }
        )
    }
}

// MARK: - Return MessageContent
public extension View {
    func onMessage <MessageContent> (
        of _: MessageContent.Type = MessageContent.self,
        isCompleting: Bool = false,
        fileId: String = #fileID,
        line: Int = #line,
        perform action: @escaping (Message<MessageContent>) -> MessageContent
    ) -> some View where MessageContent: Equatable {
        modifier(
            OnMessageViewModifier<MessageContent>(
                fileId: fileId,
                line: line
            ) {
                let content = action($0)
                return (isCompleting ? .complete : .continue, content)
            }
        )
    }

    func onMessage <MessageContent> (
        of allowedValues: MessageContent...,
        isCompleting: Bool = false,
        fileId: String = #fileID,
        line: Int = #line,
        perform action: @escaping (Message<MessageContent>) -> MessageContent
    ) -> some View where MessageContent: Equatable {
        modifier(
            OnMessageViewModifier<MessageContent>(
                allowedValues: allowedValues,
                fileId: fileId,
                line: line
            ) {
                let content = action($0)
                return (isCompleting ? .complete : .continue, content)
            }
        )
    }

    func onMessage <MessageContent> (
        of _: MessageContent.Type = MessageContent.self,
        isCompleting: Bool = false,
        fileId: String = #fileID,
        line: Int = #line,
        perform action: @escaping (MessageContent) -> MessageContent
    ) -> some View where MessageContent: Equatable {
        modifier(
            OnMessageViewModifier<MessageContent>(
                fileId: fileId,
                line: line
            ) {
                let content = action($0.content)
                return (isCompleting ? .complete : .continue, content)
            }
        )
    }

    func onMessage <MessageContent> (
        of allowedValues: MessageContent...,
        isCompleting: Bool = false,
        fileId: String = #fileID,
        line: Int = #line,
        perform action: @escaping (MessageContent) -> MessageContent
    ) -> some View where MessageContent: Equatable {
        modifier(
            OnMessageViewModifier<MessageContent>(
                allowedValues: allowedValues,
                fileId: fileId,
                line: line
            ) {
                let content = action($0.content)
                return (isCompleting ? .complete : .continue, content)
            }
        )
    }

    func onMessage <MessageContent> (
        of _: MessageContent.Type = MessageContent.self,
        isCompleting: Bool = false,
        fileId: String = #fileID,
        line: Int = #line,
        perform action: @escaping () -> MessageContent
    ) -> some View where MessageContent: Equatable {
        modifier(
            OnMessageViewModifier<MessageContent>(
                fileId: fileId,
                line: line
            ) { _ in
                let content = action()
                return (isCompleting ? .complete : .continue, content)
            }
        )
    }

    func onMessage <MessageContent> (
        of allowedValues: MessageContent...,
        isCompleting: Bool = false,
        fileId: String = #fileID,
        line: Int = #line,
        perform action: @escaping () -> MessageContent
    ) -> some View where MessageContent: Equatable {
        modifier(
            OnMessageViewModifier<MessageContent>(
                allowedValues: allowedValues,
                fileId: fileId,
                line: line
            ) { _ in
                let content = action()
                return (isCompleting ? .complete : .continue, content)
            }
        )
    }
}

// MARK: - Return Void
public extension View {
    func onMessage <MessageContent> (
        of _: MessageContent.Type = MessageContent.self,
        isCompleting: Bool = false,
        fileId: String = #fileID,
        line: Int = #line,
        perform action: @escaping (Message<MessageContent>) -> Void
    ) -> some View where MessageContent: Equatable {
        modifier(
            OnMessageViewModifier<MessageContent>(
                fileId: fileId,
                line: line
            ) {
                action($0)
                return (isCompleting ? .complete : .continue, $0.content)
            }
        )
    }

    func onMessage <MessageContent> (
        of allowedValues: MessageContent...,
        isCompleting: Bool = false,
        fileId: String = #fileID,
        line: Int = #line,
        perform action: @escaping (Message<MessageContent>) -> Void
    ) -> some View where MessageContent: Equatable {
        modifier(
            OnMessageViewModifier<MessageContent>(
                allowedValues: allowedValues,
                fileId: fileId,
                line: line
            ) {
                action($0)
                return (isCompleting ? .complete : .continue, $0.content)
            }
        )
    }

    func onMessage <MessageContent> (
        of _: MessageContent.Type = MessageContent.self,
        isCompleting: Bool = false,
        fileId: String = #fileID,
        line: Int = #line,
        perform action: @escaping (MessageContent) -> Void
    ) -> some View where MessageContent: Equatable {
        modifier(
            OnMessageViewModifier<MessageContent>(
                fileId: fileId,
                line: line
            ) {
                action($0.content)
                return (isCompleting ? .complete : .continue, $0.content)
            }
        )
    }

    func onMessage <MessageContent> (
        of allowedValues: MessageContent...,
        isCompleting: Bool = false,
        fileId: String = #fileID,
        line: Int = #line,
        perform action: @escaping (MessageContent) -> Void
    ) -> some View where MessageContent: Equatable {
        modifier(
            OnMessageViewModifier<MessageContent>(
                allowedValues: allowedValues,
                fileId: fileId,
                line: line
            ) {
                action($0.content)
                return (isCompleting ? .complete : .continue, $0.content)
            }
        )
    }

    func onMessage <MessageContent> (
        of _: MessageContent.Type = MessageContent.self,
        isCompleting: Bool = false,
        fileId: String = #fileID,
        line: Int = #line,
        perform action: @escaping () -> Void
    ) -> some View where MessageContent: Equatable {
        modifier(
            OnMessageViewModifier<MessageContent>(
                fileId: fileId,
                line: line
            ) {
                action()
                return (isCompleting ? .complete : .continue, $0.content)
            }
        )
    }

    func onMessage <MessageContent> (
        of allowedValues: MessageContent...,
        isCompleting: Bool = false,
        fileId: String = #fileID,
        line: Int = #line,
        perform action: @escaping () -> Void
    ) -> some View where MessageContent: Equatable {
        modifier(
            OnMessageViewModifier<MessageContent>(
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
