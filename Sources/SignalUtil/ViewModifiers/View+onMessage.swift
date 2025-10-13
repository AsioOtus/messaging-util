import SwiftUI

// MARK: - Return (ProcessingAction, SignalPayload)
public extension View {
    func onSignalWithMeta <SignalPayload> (
        of _: SignalPayload.Type = SignalPayload.self,
        fileId: String = #fileID,
        line: Int = #line,
        perform action: @escaping (Signal<SignalPayload>) async throws -> (ProcessingAction, SignalPayload)
    ) -> some View where SignalPayload: Sendable, SignalPayload: Equatable {
        modifier(
            OnSignalViewModifier<SignalPayload>(
                fileId: fileId,
                line: line,
                handler: action
            )
        )
    }

    func onSignal <SignalPayload> (
        of _: SignalPayload.Type = SignalPayload.self,
        fileId: String = #fileID,
        line: Int = #line,
        perform action: @escaping (SignalPayload) async throws -> (ProcessingAction, SignalPayload)
    ) -> some View where SignalPayload: Sendable, SignalPayload: Equatable {
        modifier(
            OnSignalViewModifier<SignalPayload>(
                fileId: fileId,
                line: line
            ) {
                try await action($0.payload)
            }
        )
    }

    func onSignal <SignalPayload> (
        of _: SignalPayload.Type = SignalPayload.self,
        fileId: String = #fileID,
        line: Int = #line,
        perform action: @escaping () async throws -> (ProcessingAction, SignalPayload)
    ) -> some View where SignalPayload: Sendable, SignalPayload: Equatable {
        modifier(
            OnSignalViewModifier<SignalPayload>(
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
    func onSignalWithMeta <SignalPayload> (
        of _: SignalPayload.Type = SignalPayload.self,
        fileId: String = #fileID,
        line: Int = #line,
        perform action: @escaping (Signal<SignalPayload>) async throws -> ProcessingAction
    ) -> some View where SignalPayload: Sendable, SignalPayload: Equatable {
        modifier(
            OnSignalViewModifier<SignalPayload>(
                fileId: fileId,
                line: line
            ) {
                let processingAction = try await action($0)
                return (processingAction, $0.payload)

            }
        )
    }

    func onSignal <SignalPayload> (
        of _: SignalPayload.Type,
        fileId: String = #fileID,
        line: Int = #line,
        perform action: @escaping (SignalPayload) async throws -> ProcessingAction
    ) -> some View where SignalPayload: Sendable, SignalPayload: Equatable {
        modifier(
            OnSignalViewModifier<SignalPayload>(
                fileId: fileId,
                line: line
            ) {
                let processingAction = try await action($0.payload)
                return (processingAction, $0.payload)

            }
        )
    }

    func onSignal <SignalPayload> (
        of _: SignalPayload.Type = SignalPayload.self,
        fileId: String = #fileID,
        line: Int = #line,
        perform action: @escaping () async throws -> ProcessingAction
    ) -> some View where SignalPayload: Sendable, SignalPayload: Equatable {
        modifier(
            OnSignalViewModifier<SignalPayload>(
                fileId: fileId,
                line: line
            ) {
                let processingAction = try await action()
                return (processingAction, $0.payload)

            }
        )
    }
}

// MARK: - Return SignalPayload
public extension View {
    func onSignalWithMeta <SignalPayload> (
        of _: SignalPayload.Type = SignalPayload.self,
        isCompleting: Bool = false,
        fileId: String = #fileID,
        line: Int = #line,
        perform action: @escaping (Signal<SignalPayload>) async throws -> SignalPayload
    ) -> some View where SignalPayload: Sendable, SignalPayload: Equatable {
        modifier(
            OnSignalViewModifier<SignalPayload>(
                fileId: fileId,
                line: line
            ) {
                let content = try await action($0)
                return (isCompleting ? .complete : .continue, content)
            }
        )
    }

    func onSignal <SignalPayload> (
        of _: SignalPayload.Type = SignalPayload.self,
        isCompleting: Bool = false,
        fileId: String = #fileID,
        line: Int = #line,
        perform action: @escaping (SignalPayload) async throws -> SignalPayload
    ) -> some View where SignalPayload: Sendable, SignalPayload: Equatable {
        modifier(
            OnSignalViewModifier<SignalPayload>(
                fileId: fileId,
                line: line
            ) {
                let content = try await action($0.payload)
                return (isCompleting ? .complete : .continue, content)
            }
        )
    }

    func onSignal <SignalPayload> (
        of _: SignalPayload.Type = SignalPayload.self,
        isCompleting: Bool = false,
        fileId: String = #fileID,
        line: Int = #line,
        perform action: @escaping () async throws -> SignalPayload
    ) -> some View where SignalPayload: Sendable, SignalPayload: Equatable {
        modifier(
            OnSignalViewModifier<SignalPayload>(
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
    func onSignalWithMeta <SignalPayload> (
        of _: SignalPayload.Type = SignalPayload.self,
        isCompleting: Bool = false,
        fileId: String = #fileID,
        line: Int = #line,
        perform action: @escaping (Signal<SignalPayload>) async throws -> Void
    ) -> some View where SignalPayload: Sendable, SignalPayload: Equatable {
        modifier(
            OnSignalViewModifier<SignalPayload>(
                fileId: fileId,
                line: line
            ) {
                try await action($0)
                return (isCompleting ? .complete : .continue, $0.payload)
            }
        )
    }

    func onSignal <SignalPayload> (
        of _: SignalPayload.Type = SignalPayload.self,
        isCompleting: Bool = false,
        fileId: String = #fileID,
        line: Int = #line,
        perform action: @escaping (SignalPayload) async throws -> Void
    ) -> some View where SignalPayload: Sendable, SignalPayload: Equatable {
        modifier(
            OnSignalViewModifier<SignalPayload>(
                fileId: fileId,
                line: line
            ) {
                try await action($0.payload)
                return (isCompleting ? .complete : .continue, $0.payload)
            }
        )
    }

    func onSignal <SignalPayload> (
        of _: SignalPayload.Type = SignalPayload.self,
        isCompleting: Bool = false,
        fileId: String = #fileID,
        line: Int = #line,
        perform action: @escaping () async throws -> Void
    ) -> some View where SignalPayload: Sendable, SignalPayload: Equatable {
        modifier(
            OnSignalViewModifier<SignalPayload>(
                fileId: fileId,
                line: line
            ) {
                try await action()
                return (isCompleting ? .complete : .continue, $0.payload)
            }
        )
    }
}
