public typealias MessageHandler <MessagePayload> = (Message<MessagePayload>) async -> (ProcessingAction, MessagePayload)
