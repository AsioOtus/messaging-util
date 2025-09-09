public enum ProcessingAction {
    case process
    case `continue`
    case complete

    var messageStatus: MessageStatus {
        switch self {
        case .process: .processing
        case .continue: .dispatching
        case .complete: .completed
        }
    }
}
