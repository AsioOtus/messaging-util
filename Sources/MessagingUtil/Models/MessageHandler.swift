public typealias MessageHandler <MessagePayload> = (Message<MessagePayload>) async throws -> (ProcessingAction, MessagePayload)
