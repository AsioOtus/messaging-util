import os

struct Logger {
    let logger: os.Logger
    let name: String
    let fileId: String
    let line: Int

    init (
        name: String,
        fileId: String,
        line: Int
    ) {
        self.name = name
        self.fileId = fileId
        self.line = line
        self.logger = .init()
    }

    func log <MessagePayload> (
        _ level: LogLevel,
        _ text: String,
        _ message: Message<MessagePayload>?,
        minLevel: LogLevel
    ) {
        guard level.rawValue >= minLevel.rawValue else { return }

        switch level {
        case .notice:   logger.notice("\(preparedMessage(level, text, message))")
        case .debug:    logger.debug("\(preparedMessage(level, text, message))")
        case .trace:    logger.trace("\(preparedMessage(level, text, message))")
        case .info:     logger.info("\(preparedMessage(level, text, message))")
        case .error:    logger.error("\(preparedMessage(level, text, message))")
        case .warning:  logger.warning("\(preparedMessage(level, text, message))")
        case .fault:    logger.fault("\(preparedMessage(level, text, message))")
        case .critical: logger.critical("\(preparedMessage(level, text, message))")
        case .none:     break
        }
    }

    func preparedMessage <MessagePayload> (
        _ level: LogLevel,
        _ text: String,
        _ message: Message<MessagePayload>?,
    ) -> String {
        let level = String(describing: level)
        let location = "\(name) (\(fileId):\(line))"
        let message = message?.description ?? "nil"

        let result = "messaging-util [\(level)] | \(location) | \(text) – \(message)"
        return result
    }
}
