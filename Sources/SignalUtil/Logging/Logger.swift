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

    func log <SignalPayload> (
        _ level: LogLevel,
        _ text: String,
        _ signal: Signal<SignalPayload>?,
        minLevel: LogLevel
    ) {
        guard level.rawValue >= minLevel.rawValue else { return }

        switch level {
        case .all:      break
        case .notice:   logger.notice("\(preparedSignal(level, text, signal))")
        case .debug:    logger.debug("\(preparedSignal(level, text, signal))")
        case .trace:    logger.trace("\(preparedSignal(level, text, signal))")
        case .info:     logger.info("\(preparedSignal(level, text, signal))")
        case .error:    logger.error("\(preparedSignal(level, text, signal))")
        case .warning:  logger.warning("\(preparedSignal(level, text, signal))")
        case .fault:    logger.fault("\(preparedSignal(level, text, signal))")
        case .critical: logger.critical("\(preparedSignal(level, text, signal))")
        case .none:     break
        }
    }

    func preparedSignal <SignalPayload> (
        _ level: LogLevel,
        _ text: String,
        _ signal: Signal<SignalPayload>?,
    ) -> String {
        let level = String(describing: level)
        let location = "\(name) (\(fileId):\(line))"
        let signal = signal?.description ?? "nil"

        let result = "messaging-util [\(level)] | \(location) | \(text) | \(signal)"
        return result
    }
}
