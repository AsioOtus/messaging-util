import SwiftUI

// MARK: - Return (ProcessingAction, MessagePayload)
public extension View {
    func onMessage <MessagePayload> (
        of _: MessagePayload.Type = MessagePayload.self,
        fileId: String = #fileID,
        line: Int = #line,
        perform action: @escaping (Message<MessagePayload>) async -> (ProcessingAction, MessagePayload)
    ) -> some View where MessagePayload: Sendable {
        modifier(
            OnMessageViewModifier<MessagePayload>(
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
        perform action: @escaping (MessagePayload) async -> (ProcessingAction, MessagePayload)
    ) -> some View where MessagePayload: Sendable {
        modifier(
            OnMessageViewModifier<MessagePayload>(
                fileId: fileId,
                line: line
            ) {
                await action($0.payload)
            }
        )
    }

    func onMessage <MessagePayload> (
        of _: MessagePayload.Type = MessagePayload.self,
        fileId: String = #fileID,
        line: Int = #line,
        perform action: @escaping () async -> (ProcessingAction, MessagePayload)
    ) -> some View where MessagePayload: Sendable {
        modifier(
            OnMessageViewModifier<MessagePayload>(
                fileId: fileId,
                line: line
            ) { _ in
                await action()
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
        perform action: @escaping (Message<MessagePayload>) async -> ProcessingAction
    ) -> some View where MessagePayload: Sendable {
        modifier(
            OnMessageViewModifier<MessagePayload>(
                fileId: fileId,
                line: line
            ) {
                let processingAction = await action($0)
                return (processingAction, $0.payload)

            }
        )
    }

    func onMessage <MessagePayload> (
        of _: MessagePayload.Type,
        fileId: String = #fileID,
        line: Int = #line,
        perform action: @escaping (MessagePayload) async -> ProcessingAction
    ) -> some View where MessagePayload: Sendable {
        modifier(
            OnMessageViewModifier<MessagePayload>(
                fileId: fileId,
                line: line
            ) {
                let processingAction = await action($0.payload)
                return (processingAction, $0.payload)

            }
        )
    }

    func onMessage <MessagePayload> (
        of _: MessagePayload.Type = MessagePayload.self,
        fileId: String = #fileID,
        line: Int = #line,
        perform action: @escaping () async -> ProcessingAction
    ) -> some View where MessagePayload: Sendable {
        modifier(
            OnMessageViewModifier<MessagePayload>(
                fileId: fileId,
                line: line
            ) {
                let processingAction = await action()
                return (processingAction, $0.payload)

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
        perform action: @escaping (Message<MessagePayload>) async -> MessagePayload
    ) -> some View where MessagePayload: Sendable {
        modifier(
            OnMessageViewModifier<MessagePayload>(
                fileId: fileId,
                line: line
            ) {
                let content = await action($0)
                return (isCompleting ? .complete : .continue, content)
            }
        )
    }

    func onMessage <MessagePayload> (
        of _: MessagePayload.Type = MessagePayload.self,
        isCompleting: Bool = false,
        fileId: String = #fileID,
        line: Int = #line,
        perform action: @escaping (MessagePayload) async -> MessagePayload
    ) -> some View where MessagePayload: Sendable {
        modifier(
            OnMessageViewModifier<MessagePayload>(
                fileId: fileId,
                line: line
            ) {
                let content = await action($0.payload)
                return (isCompleting ? .complete : .continue, content)
            }
        )
    }

    func onMessage <MessagePayload> (
        of _: MessagePayload.Type = MessagePayload.self,
        isCompleting: Bool = false,
        fileId: String = #fileID,
        line: Int = #line,
        perform action: @escaping () async -> MessagePayload
    ) -> some View where MessagePayload: Sendable {
        modifier(
            OnMessageViewModifier<MessagePayload>(
                fileId: fileId,
                line: line
            ) { _ in
                let content = await action()
                return (isCompleting ? .complete : .continue, content)
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
        perform action: @escaping (Message<MessagePayload>) async -> Void
    ) -> some View where MessagePayload: Sendable {
        modifier(
            OnMessageViewModifier<MessagePayload>(
                fileId: fileId,
                line: line
            ) {
                await action($0)
                return (isCompleting ? .complete : .continue, $0.payload)
            }
        )
    }

    func onMessage <MessagePayload> (
        of _: MessagePayload.Type = MessagePayload.self,
        isCompleting: Bool = false,
        fileId: String = #fileID,
        line: Int = #line,
        perform action: @escaping (MessagePayload) async -> Void
    ) -> some View where MessagePayload: Sendable {
        modifier(
            OnMessageViewModifier<MessagePayload>(
                fileId: fileId,
                line: line
            ) {
                await action($0.payload)
                return (isCompleting ? .complete : .continue, $0.payload)
            }
        )
    }

    func onMessage <MessagePayload> (
        of _: MessagePayload.Type = MessagePayload.self,
        isCompleting: Bool = false,
        fileId: String = #fileID,
        line: Int = #line,
        perform action: @escaping () async -> Void
    ) -> some View where MessagePayload: Sendable {
        modifier(
            OnMessageViewModifier<MessagePayload>(
                fileId: fileId,
                line: line
            ) {
                await action()
                return (isCompleting ? .complete : .continue, $0.payload)
            }
        )
    }
}
