public enum ProcessingAction: Sendable {
    case process
    case `continue`
    case complete
    case fail(Error)

    var messageStatus: MessageStatus {
        switch self {
        case .process: .processing
        case .continue: .dispatching
        case .complete: .completed(nil)
        case .fail(let error): .completed(error)
        }
    }
}
