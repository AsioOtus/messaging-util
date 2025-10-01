import SwiftUI

extension EnvironmentValues {
    @Entry var signalLogLevel = LogLevel.none
}

public extension View {
    func signalLogLevel (_ level: LogLevel) -> some View {
        self.environment(\.signalLogLevel, level)
    }
}
