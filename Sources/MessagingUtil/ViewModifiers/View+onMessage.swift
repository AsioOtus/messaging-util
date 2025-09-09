import SwiftUI

// MARK: - Return (ProcessingAction, MessagePayload)
public extension View {
    func onMessage <MessagePayload> (
        of _: MessagePayload.Type = MessagePayload.self,
        fileId: String = #fileID,
        line: Int = #line,
        perform action: @escaping MessageHandler<MessagePayload>
    ) -> some View where MessagePayload: Equatable {
        modifier(
            OnMessageViewModifier<MessagePayload>(
                fileId: fileId,
                line: line,
                handler: action
            )
        )
    }

    func onMessage <MessagePayload> (
        of allowedValues: MessagePayload...,
        fileId: String = #fileID,
        line: Int = #line,
        perform action: @escaping MessageHandler<MessagePayload>
    ) -> some View where MessagePayload: Equatable {
        modifier(
            OnMessageViewModifier<MessagePayload>(
                allowedValues: allowedValues,
                fileId: fileId,
                line: line,
                handler: action
            )
        )
    }

    func onMessage <MessagePayload> (
        of _: MessagePayload.Type = MessagePayload.self,
        fileId: String = #fileID,
        line: Int = #line,
        perform action: @escaping (MessagePayload, (ProcessingAction, MessagePayload) -> Void) -> Void
    ) -> some View where MessagePayload: Equatable {
        modifier(
            OnMessageViewModifier<MessagePayload>(
                fileId: fileId,
                line: line
            ) {
                action($0.payload, $1)
            }
        )
    }

    func onMessage <MessagePayload> (
        of allowedValues: MessagePayload...,
        fileId: String = #fileID,
        line: Int = #line,
        perform action: @escaping (MessagePayload, (ProcessingAction, MessagePayload) -> Void) -> Void
    ) -> some View where MessagePayload: Equatable {
        modifier(
            OnMessageViewModifier<MessagePayload>(
                allowedValues: allowedValues,
                fileId: fileId,
                line: line
            ) {
                action($0.payload, $1)
            }
        )
    }

    func onMessage <MessagePayload> (
        of _: MessagePayload.Type = MessagePayload.self,
        fileId: String = #fileID,
        line: Int = #line,
        perform action: @escaping ((ProcessingAction, MessagePayload) -> Void) -> Void
    ) -> some View where MessagePayload: Equatable {
        modifier(
            OnMessageViewModifier<MessagePayload>(
                fileId: fileId,
                line: line
            ) {
                action($1)
            }
        )
    }

    func onMessage <MessagePayload> (
        of allowedValues: MessagePayload...,
        fileId: String = #fileID,
        line: Int = #line,
        perform action: @escaping ((ProcessingAction, MessagePayload) -> Void) -> Void
    ) -> some View where MessagePayload: Equatable {
        modifier(
            OnMessageViewModifier<MessagePayload>(
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
    func onMessage <MessagePayload> (
        of _: MessagePayload.Type = MessagePayload.self,
        fileId: String = #fileID,
        line: Int = #line,
        perform action: @escaping (Message<MessagePayload>, (ProcessingAction) -> Void) -> Void
    ) -> some View where MessagePayload: Equatable {
        modifier(
            OnMessageViewModifier<MessagePayload>(
                fileId: fileId,
                line: line
            ) { message, completion in
                action(message) {
                    completion($0, message.payload)
                }
            }
        )
    }

    func onMessage <MessagePayload> (
        of allowedValues: MessagePayload...,
        fileId: String = #fileID,
        line: Int = #line,
        perform action: @escaping (Message<MessagePayload>, (ProcessingAction) -> Void) -> Void
    ) -> some View where MessagePayload: Equatable {
        modifier(
            OnMessageViewModifier<MessagePayload>(
                allowedValues: allowedValues,
                fileId: fileId,
                line: line
            ) { message, completion in
                action(message) {
                    completion($0, message.payload)
                }
            }
        )
    }

    func onMessage <MessagePayload> (
        of _: MessagePayload.Type,
        fileId: String = #fileID,
        line: Int = #line,
        perform action: @escaping (MessagePayload, (ProcessingAction) -> Void) -> Void
    ) -> some View where MessagePayload: Equatable {
        modifier(
            OnMessageViewModifier<MessagePayload>(
                fileId: fileId,
                line: line
            ) { message, completion in
                action(message.payload) {
                    completion($0, message.payload)
                }
            }
        )
    }

    func onMessage <MessagePayload> (
        of allowedValues: MessagePayload...,
        fileId: String = #fileID,
        line: Int = #line,
        perform action: @escaping (MessagePayload, (ProcessingAction) -> Void) -> Void
    ) -> some View where MessagePayload: Equatable {
        modifier(
            OnMessageViewModifier<MessagePayload>(
                allowedValues: allowedValues,
                fileId: fileId,
                line: line
            ) { message, completion in
                action(message.payload) {
                    completion($0, message.payload)
                }
            }
        )
    }

    func onMessage <MessagePayload> (
        of _: MessagePayload.Type = MessagePayload.self,
        fileId: String = #fileID,
        line: Int = #line,
        perform action: @escaping ((ProcessingAction) -> Void) -> Void
    ) -> some View where MessagePayload: Equatable {
        modifier(
            OnMessageViewModifier<MessagePayload>(
                fileId: fileId,
                line: line
            ) { message, completion in
                action {
                    completion($0, message.payload)
                }
            }
        )
    }

    func onMessage <MessagePayload> (
        of allowedValues: MessagePayload...,
        fileId: String = #fileID,
        line: Int = #line,
        perform action: @escaping ((ProcessingAction) -> Void) -> Void
    ) -> some View where MessagePayload: Equatable {
        modifier(
            OnMessageViewModifier<MessagePayload>(
                allowedValues: allowedValues,
                fileId: fileId,
                line: line
            ) { message, completion in
                action {
                    completion($0, message.payload)
                }
            }
        )
    }
}

// MARK: - Return MessagePayload
public extension View {
    func onMessage <MessagePayload> (
        of _: MessagePayload.Type = MessagePayload.self,
        isCompleting: Bool = false,
        fileId: String = #fileID,
        line: Int = #line,
        perform action: @escaping (Message<MessagePayload>, (MessagePayload) -> Void) -> Void
    ) -> some View where MessagePayload: Equatable {
        modifier(
            OnMessageViewModifier<MessagePayload>(
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

    func onMessage <MessagePayload> (
        of allowedValues: MessagePayload...,
        isCompleting: Bool = false,
        fileId: String = #fileID,
        line: Int = #line,
        perform action: @escaping (Message<MessagePayload>, (MessagePayload) -> Void) -> Void
    ) -> some View where MessagePayload: Equatable {
        modifier(
            OnMessageViewModifier<MessagePayload>(
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

    func onMessage <MessagePayload> (
        of _: MessagePayload.Type = MessagePayload.self,
        isCompleting: Bool = false,
        fileId: String = #fileID,
        line: Int = #line,
        perform action: @escaping (MessagePayload, (MessagePayload) -> Void) -> Void
    ) -> some View where MessagePayload: Equatable {
        modifier(
            OnMessageViewModifier<MessagePayload>(
                fileId: fileId,
                line: line
            ) { message, completion in
                action(message.payload) {
                    completion(
                        isCompleting ? .complete : .continue,
                        $0
                    )
                }
            }
        )
    }

    func onMessage <MessagePayload> (
        of allowedValues: MessagePayload...,
        isCompleting: Bool = false,
        fileId: String = #fileID,
        line: Int = #line,
        perform action: @escaping (MessagePayload, (MessagePayload) -> Void) -> Void
    ) -> some View where MessagePayload: Equatable {
        modifier(
            OnMessageViewModifier<MessagePayload>(
                allowedValues: allowedValues,
                fileId: fileId,
                line: line
            ) { message, completion in
                action(message.payload) {
                    completion(
                        isCompleting ? .complete : .continue,
                        $0
                    )
                }
            }
        )
    }

    func onMessage <MessagePayload> (
        of _: MessagePayload.Type = MessagePayload.self,
        isCompleting: Bool = false,
        fileId: String = #fileID,
        line: Int = #line,
        perform action: @escaping ((MessagePayload) -> Void) -> Void
    ) -> some View where MessagePayload: Equatable {
        modifier(
            OnMessageViewModifier<MessagePayload>(
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

    func onMessage <MessagePayload> (
        of allowedValues: MessagePayload...,
        isCompleting: Bool = false,
        fileId: String = #fileID,
        line: Int = #line,
        perform action: @escaping ((MessagePayload) -> Void) -> Void
    ) -> some View where MessagePayload: Equatable {
        modifier(
            OnMessageViewModifier<MessagePayload>(
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
    func onMessage <MessagePayload> (
        of _: MessagePayload.Type = MessagePayload.self,
        isCompleting: Bool = false,
        fileId: String = #fileID,
        line: Int = #line,
        perform action: @escaping (Message<MessagePayload>) -> Void
    ) -> some View where MessagePayload: Equatable {
        modifier(
            OnMessageViewModifier<MessagePayload>(
                fileId: fileId,
                line: line
            ) { message, completion in
                action(message)
                completion(isCompleting ? .complete : .continue, message.payload)
            }
        )
    }

    func onMessage <MessagePayload> (
        of allowedValues: MessagePayload...,
        isCompleting: Bool = false,
        fileId: String = #fileID,
        line: Int = #line,
        perform action: @escaping (Message<MessagePayload>) -> Void
    ) -> some View where MessagePayload: Equatable {
        modifier(
            OnMessageViewModifier<MessagePayload>(
                allowedValues: allowedValues,
                fileId: fileId,
                line: line
            ) { message, completion in
                action(message)
                completion(isCompleting ? .complete : .continue, message.payload)
            }
        )
    }

    func onMessage <MessagePayload> (
        of _: MessagePayload.Type = MessagePayload.self,
        isCompleting: Bool = false,
        fileId: String = #fileID,
        line: Int = #line,
        perform action: @escaping (MessagePayload) -> Void
    ) -> some View where MessagePayload: Equatable {
        modifier(
            OnMessageViewModifier<MessagePayload>(
                fileId: fileId,
                line: line
            ) { message, completion in
                action(message.payload)
                completion(isCompleting ? .complete : .continue, message.payload)
            }
        )
    }

    func onMessage <MessagePayload> (
        of allowedValues: MessagePayload...,
        isCompleting: Bool = false,
        fileId: String = #fileID,
        line: Int = #line,
        perform action: @escaping (MessagePayload) -> Void
    ) -> some View where MessagePayload: Equatable {
        modifier(
            OnMessageViewModifier<MessagePayload>(
                allowedValues: allowedValues,
                fileId: fileId,
                line: line
            ) { message, completion in
                action(message.payload)
                completion(isCompleting ? .complete : .continue, message.payload)
            }
        )
    }

    func onMessage <MessagePayload> (
        of _: MessagePayload.Type = MessagePayload.self,
        isCompleting: Bool = false,
        fileId: String = #fileID,
        line: Int = #line,
        perform action: @escaping () -> Void
    ) -> some View where MessagePayload: Equatable {
        modifier(
            OnMessageViewModifier<MessagePayload>(
                fileId: fileId,
                line: line
            ) { message, completion in
                action()
                completion(isCompleting ? .complete : .continue, message.payload)
            }
        )
    }

    func onMessage <MessagePayload> (
        of allowedValues: MessagePayload...,
        isCompleting: Bool = false,
        fileId: String = #fileID,
        line: Int = #line,
        perform action: @escaping () -> Void
    ) -> some View where MessagePayload: Equatable {
        modifier(
            OnMessageViewModifier<MessagePayload>(
                allowedValues: allowedValues,
                fileId: fileId,
                line: line
            ) { message, completion in
                action()
                completion(isCompleting ? .complete : .continue, message.payload)
            }
        )
    }
}
