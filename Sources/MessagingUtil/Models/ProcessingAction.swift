public enum ProcessingAction {
    case `continue`
    case complete

    var messageStatus: MessageStatus {
        switch self {
        case .continue: .incomplete
        case .complete: .completed
        }
    }
}
