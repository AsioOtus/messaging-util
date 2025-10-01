public typealias SignalHandler <SignalPayload> = (Signal<SignalPayload>) async throws -> (ProcessingAction, SignalPayload)
