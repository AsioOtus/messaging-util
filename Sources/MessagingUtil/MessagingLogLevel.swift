import SwiftUI

extension EnvironmentValues {
    @Entry var messagingLogLevel = LogLevel.none
}

public extension View {
    func messagingLogLevel (_ level: LogLevel) -> some View {
        self.environment(\.messagingLogLevel, level)
    }
}
