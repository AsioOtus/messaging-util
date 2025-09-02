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

    func log (_ level: LogLevel, _ message: String, minLevel: LogLevel) {
        guard level.rawValue >= minLevel.rawValue else { return }

        switch level {
        case .notice:   logger.notice("\(preparedMessage(level, message))")
        case .debug:    logger.debug("\(preparedMessage(level, message))")
        case .trace:    logger.trace("\(preparedMessage(level, message))")
        case .info:     logger.info("\(preparedMessage(level, message))")
        case .error:    logger.error("\(preparedMessage(level, message))")
        case .warning:  logger.warning("\(preparedMessage(level, message))")
        case .fault:    logger.fault("\(preparedMessage(level, message))")
        case .critical: logger.critical("\(preparedMessage(level, message))")
        case .none:     break
        }
    }

    func preparedMessage (_ level: LogLevel, _ message: String) -> String {
        "[\(String(describing: level))] messaging – \(name) (\(fileId):\(line)) | \(message)"
    }
}
