public typealias MessageHandler <MessageContent: Equatable> = (Message<MessageContent>, (ProcessingAction, MessageContent) -> Void) -> Void
