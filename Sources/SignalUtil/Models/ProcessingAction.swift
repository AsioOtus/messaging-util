public enum ProcessingAction: Sendable {
    case process
    case `continue`
    case complete
    case fail(Error)

    var signalStatus: SignalStatus {
        switch self {
        case .process: .processing
        case .continue: .dispatching
        case .complete: .completed(nil)
        case .fail(let error): .completed(error)
        }
    }

    public init (catching action: () async throws -> ProcessingAction) async {
        do {
            self = try await action()
        } catch {
            self = .fail(error)
        }
    }
}
