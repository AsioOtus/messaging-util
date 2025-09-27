import SwiftUI

// MARK: - Return (ProcessingAction, MessagePayload)
public extension View {
    func onMessageWithMeta <MessagePayload> (
        of _: MessagePayload.Type = MessagePayload.self,
        fileId: String = #fileID,
        line: Int = #line,
        perform action: @escaping (Message<MessagePayload>) async throws -> (ProcessingAction, MessagePayload)
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
        perform action: @escaping (MessagePayload) async throws -> (ProcessingAction, MessagePayload)
    ) -> some View where MessagePayload: Sendable {
        modifier(
            OnMessageViewModifier<MessagePayload>(
                fileId: fileId,
                line: line
            ) {
                try await action($0.payload)
            }
        )
    }

    func onMessage <MessagePayload> (
        of _: MessagePayload.Type = MessagePayload.self,
        fileId: String = #fileID,
        line: Int = #line,
        perform action: @escaping () async throws -> (ProcessingAction, MessagePayload)
    ) -> some View where MessagePayload: Sendable {
        modifier(
            OnMessageViewModifier<MessagePayload>(
                fileId: fileId,
                line: line
            ) { _ in
                try  await action()
            }
        )
    }
}

// MARK: - Return ProcessingAction
public extension View {
    func onMessageWithMeta <MessagePayload> (
        of _: MessagePayload.Type = MessagePayload.self,
        fileId: String = #fileID,
        line: Int = #line,
        perform action: @escaping (Message<MessagePayload>) async throws -> ProcessingAction
    ) -> some View where MessagePayload: Sendable {
        modifier(
            OnMessageViewModifier<MessagePayload>(
                fileId: fileId,
                line: line
            ) {
                let processingAction = try await action($0)
                return (processingAction, $0.payload)

            }
        )
    }

    func onMessage <MessagePayload> (
        of _: MessagePayload.Type,
        fileId: String = #fileID,
        line: Int = #line,
        perform action: @escaping (MessagePayload) async throws -> ProcessingAction
    ) -> some View where MessagePayload: Sendable {
        modifier(
            OnMessageViewModifier<MessagePayload>(
                fileId: fileId,
                line: line
            ) {
                let processingAction = try await action($0.payload)
                return (processingAction, $0.payload)

            }
        )
    }

    func onMessage <MessagePayload> (
        of _: MessagePayload.Type = MessagePayload.self,
        fileId: String = #fileID,
        line: Int = #line,
        perform action: @escaping () async throws -> ProcessingAction
    ) -> some View where MessagePayload: Sendable {
        modifier(
            OnMessageViewModifier<MessagePayload>(
                fileId: fileId,
                line: line
            ) {
                let processingAction = try await action()
                return (processingAction, $0.payload)

            }
        )
    }
}

// MARK: - Return MessagePayload
public extension View {
    func onMessageWithMeta <MessagePayload> (
        of _: MessagePayload.Type = MessagePayload.self,
        isCompleting: Bool = false,
        fileId: String = #fileID,
        line: Int = #line,
        perform action: @escaping (Message<MessagePayload>) async throws -> MessagePayload
    ) -> some View where MessagePayload: Sendable {
        modifier(
            OnMessageViewModifier<MessagePayload>(
                fileId: fileId,
                line: line
            ) {
                let content = try await action($0)
                return (isCompleting ? .complete : .continue, content)
            }
        )
    }

    func onMessage <MessagePayload> (
        of _: MessagePayload.Type = MessagePayload.self,
        isCompleting: Bool = false,
        fileId: String = #fileID,
        line: Int = #line,
        perform action: @escaping (MessagePayload) async throws -> MessagePayload
    ) -> some View where MessagePayload: Sendable {
        modifier(
            OnMessageViewModifier<MessagePayload>(
                fileId: fileId,
                line: line
            ) {
                let content = try await action($0.payload)
                return (isCompleting ? .complete : .continue, content)
            }
        )
    }

    func onMessage <MessagePayload> (
        of _: MessagePayload.Type = MessagePayload.self,
        isCompleting: Bool = false,
        fileId: String = #fileID,
        line: Int = #line,
        perform action: @escaping () async throws -> MessagePayload
    ) -> some View where MessagePayload: Sendable {
        modifier(
            OnMessageViewModifier<MessagePayload>(
                fileId: fileId,
                line: line
            ) { _ in
                let content = try await action()
                return (isCompleting ? .complete : .continue, content)
            }
        )
    }
}

// MARK: - Return Void
public extension View {
    func onMessageWithMeta <MessagePayload> (
        of _: MessagePayload.Type = MessagePayload.self,
        isCompleting: Bool = false,
        fileId: String = #fileID,
        line: Int = #line,
        perform action: @escaping (Message<MessagePayload>) async throws -> Void
    ) -> some View where MessagePayload: Sendable {
        modifier(
            OnMessageViewModifier<MessagePayload>(
                fileId: fileId,
                line: line
            ) {
                try await action($0)
                return (isCompleting ? .complete : .continue, $0.payload)
            }
        )
    }

    func onMessage <MessagePayload> (
        of _: MessagePayload.Type = MessagePayload.self,
        isCompleting: Bool = false,
        fileId: String = #fileID,
        line: Int = #line,
        perform action: @escaping (MessagePayload) async throws -> Void
    ) -> some View where MessagePayload: Sendable {
        modifier(
            OnMessageViewModifier<MessagePayload>(
                fileId: fileId,
                line: line
            ) {
                try await action($0.payload)
                return (isCompleting ? .complete : .continue, $0.payload)
            }
        )
    }

    func onMessage <MessagePayload> (
        of _: MessagePayload.Type = MessagePayload.self,
        isCompleting: Bool = false,
        fileId: String = #fileID,
        line: Int = #line,
        perform action: @escaping () async throws -> Void
    ) -> some View where MessagePayload: Sendable {
        modifier(
            OnMessageViewModifier<MessagePayload>(
                fileId: fileId,
                line: line
            ) {
                try await action()
                return (isCompleting ? .complete : .continue, $0.payload)
            }
        )
    }
}
