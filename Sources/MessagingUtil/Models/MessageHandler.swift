public typealias MessageHandler <MessagePayload: Equatable> = (Message<MessagePayload>, (ProcessingAction, MessagePayload) -> Void) -> Void
