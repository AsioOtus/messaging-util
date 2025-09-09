import SwiftUI

// MARK: - Return (ProcessingAction, MessageContent)
public extension View {
    func onMessage <MessageContent> (
        of _: MessageContent.Type = MessageContent.self,
        fileId: String = #fileID,
        line: Int = #line,
        perform action: @escaping MessageHandler<MessageContent>
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
        perform action: @escaping MessageHandler<MessageContent>
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
        perform action: @escaping (MessageContent, (ProcessingAction, MessageContent) -> Void) -> Void
    ) -> some View where MessageContent: Equatable {
        modifier(
            OnMessageViewModifier<MessageContent>(
                fileId: fileId,
                line: line
            ) {
                action($0.content, $1)
            }
        )
    }

    func onMessage <MessageContent> (
        of allowedValues: MessageContent...,
        fileId: String = #fileID,
        line: Int = #line,
        perform action: @escaping (MessageContent, (ProcessingAction, MessageContent) -> Void) -> Void
    ) -> some View where MessageContent: Equatable {
        modifier(
            OnMessageViewModifier<MessageContent>(
                allowedValues: allowedValues,
                fileId: fileId,
                line: line
            ) {
                action($0.content, $1)
            }
        )
    }

    func onMessage <MessageContent> (
        of _: MessageContent.Type = MessageContent.self,
        fileId: String = #fileID,
        line: Int = #line,
        perform action: @escaping ((ProcessingAction, MessageContent) -> Void) -> Void
    ) -> some View where MessageContent: Equatable {
        modifier(
            OnMessageViewModifier<MessageContent>(
                fileId: fileId,
                line: line
            ) {
                action($1)
            }
        )
    }

    func onMessage <MessageContent> (
        of allowedValues: MessageContent...,
        fileId: String = #fileID,
        line: Int = #line,
        perform action: @escaping ((ProcessingAction, MessageContent) -> Void) -> Void
    ) -> some View where MessageContent: Equatable {
        modifier(
            OnMessageViewModifier<MessageContent>(
                allowedValues: allowedValues,
                fileId: fileId,
                line: line
            ) {
                action($1)
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
        perform action: @escaping (Message<MessageContent>, (ProcessingAction) -> Void) -> Void
    ) -> some View where MessageContent: Equatable {
        modifier(
            OnMessageViewModifier<MessageContent>(
                fileId: fileId,
                line: line
            ) { message, completion in
                action(message) {
                    completion($0, message.content)
                }
            }
        )
    }

    func onMessage <MessageContent> (
        of allowedValues: MessageContent...,
        fileId: String = #fileID,
        line: Int = #line,
        perform action: @escaping (Message<MessageContent>, (ProcessingAction) -> Void) -> Void
    ) -> some View where MessageContent: Equatable {
        modifier(
            OnMessageViewModifier<MessageContent>(
                allowedValues: allowedValues,
                fileId: fileId,
                line: line
            ) { message, completion in
                action(message) {
                    completion($0, message.content)
                }
            }
        )
    }

    func onMessage <MessageContent> (
        of _: MessageContent.Type,
        fileId: String = #fileID,
        line: Int = #line,
        perform action: @escaping (MessageContent, (ProcessingAction) -> Void) -> Void
    ) -> some View where MessageContent: Equatable {
        modifier(
            OnMessageViewModifier<MessageContent>(
                fileId: fileId,
                line: line
            ) { message, completion in
                action(message.content) {
                    completion($0, message.content)
                }
            }
        )
    }

    func onMessage <MessageContent> (
        of allowedValues: MessageContent...,
        fileId: String = #fileID,
        line: Int = #line,
        perform action: @escaping (MessageContent, (ProcessingAction) -> Void) -> Void
    ) -> some View where MessageContent: Equatable {
        modifier(
            OnMessageViewModifier<MessageContent>(
                allowedValues: allowedValues,
                fileId: fileId,
                line: line
            ) { message, completion in
                action(message.content) {
                    completion($0, message.content)
                }
            }
        )
    }

    func onMessage <MessageContent> (
        of _: MessageContent.Type = MessageContent.self,
        fileId: String = #fileID,
        line: Int = #line,
        perform action: @escaping ((ProcessingAction) -> Void) -> Void
    ) -> some View where MessageContent: Equatable {
        modifier(
            OnMessageViewModifier<MessageContent>(
                fileId: fileId,
                line: line
            ) { message, completion in
                action {
                    completion($0, message.content)
                }
            }
        )
    }

    func onMessage <MessageContent> (
        of allowedValues: MessageContent...,
        fileId: String = #fileID,
        line: Int = #line,
        perform action: @escaping ((ProcessingAction) -> Void) -> Void
    ) -> some View where MessageContent: Equatable {
        modifier(
            OnMessageViewModifier<MessageContent>(
                allowedValues: allowedValues,
                fileId: fileId,
                line: line
            ) { message, completion in
                action {
                    completion($0, message.content)
                }
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
        perform action: @escaping (Message<MessageContent>, (MessageContent) -> Void) -> Void
    ) -> some View where MessageContent: Equatable {
        modifier(
            OnMessageViewModifier<MessageContent>(
                fileId: fileId,
                line: line
            ) { message, completion in
                action(message) {
                    completion(
                        isCompleting ? .complete : .continue,
                        $0
                    )
                }
            }
        )
    }

    func onMessage <MessageContent> (
        of allowedValues: MessageContent...,
        isCompleting: Bool = false,
        fileId: String = #fileID,
        line: Int = #line,
        perform action: @escaping (Message<MessageContent>, (MessageContent) -> Void) -> Void
    ) -> some View where MessageContent: Equatable {
        modifier(
            OnMessageViewModifier<MessageContent>(
                allowedValues: allowedValues,
                fileId: fileId,
                line: line
            ) { message, completion in
                action(message) {
                    completion(
                        isCompleting ? .complete : .continue,
                        $0
                    )
                }
            }
        )
    }

    func onMessage <MessageContent> (
        of _: MessageContent.Type = MessageContent.self,
        isCompleting: Bool = false,
        fileId: String = #fileID,
        line: Int = #line,
        perform action: @escaping (MessageContent, (MessageContent) -> Void) -> Void
    ) -> some View where MessageContent: Equatable {
        modifier(
            OnMessageViewModifier<MessageContent>(
                fileId: fileId,
                line: line
            ) { message, completion in
                action(message.content) {
                    completion(
                        isCompleting ? .complete : .continue,
                        $0
                    )
                }
            }
        )
    }

    func onMessage <MessageContent> (
        of allowedValues: MessageContent...,
        isCompleting: Bool = false,
        fileId: String = #fileID,
        line: Int = #line,
        perform action: @escaping (MessageContent, (MessageContent) -> Void) -> Void
    ) -> some View where MessageContent: Equatable {
        modifier(
            OnMessageViewModifier<MessageContent>(
                allowedValues: allowedValues,
                fileId: fileId,
                line: line
            ) { message, completion in
                action(message.content) {
                    completion(
                        isCompleting ? .complete : .continue,
                        $0
                    )
                }
            }
        )
    }

    func onMessage <MessageContent> (
        of _: MessageContent.Type = MessageContent.self,
        isCompleting: Bool = false,
        fileId: String = #fileID,
        line: Int = #line,
        perform action: @escaping ((MessageContent) -> Void) -> Void
    ) -> some View where MessageContent: Equatable {
        modifier(
            OnMessageViewModifier<MessageContent>(
                fileId: fileId,
                line: line
            ) { message, completion in
                action {
                    completion(
                        isCompleting ? .complete : .continue,
                        $0
                    )
                }
            }
        )
    }

    func onMessage <MessageContent> (
        of allowedValues: MessageContent...,
        isCompleting: Bool = false,
        fileId: String = #fileID,
        line: Int = #line,
        perform action: @escaping ((MessageContent) -> Void) -> Void
    ) -> some View where MessageContent: Equatable {
        modifier(
            OnMessageViewModifier<MessageContent>(
                allowedValues: allowedValues,
                fileId: fileId,
                line: line
            ) { message, completion in
                action {
                    completion(
                        isCompleting ? .complete : .continue,
                        $0
                    )
                }
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
            ) { message, completion in
                action(message)
                completion(isCompleting ? .complete : .continue, message.content)
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
            ) { message, completion in
                action(message)
                completion(isCompleting ? .complete : .continue, message.content)
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
            ) { message, completion in
                action(message.content)
                completion(isCompleting ? .complete : .continue, message.content)
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
            ) { message, completion in
                action(message.content)
                completion(isCompleting ? .complete : .continue, message.content)
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
            ) { message, completion in
                action()
                completion(isCompleting ? .complete : .continue, message.content)
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
            ) { message, completion in
                action()
                completion(isCompleting ? .complete : .continue, message.content)
            }
        )
    }
}
