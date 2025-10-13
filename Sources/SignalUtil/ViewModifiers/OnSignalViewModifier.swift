import SwiftUI

struct OnSignalViewModifier <SignalPayload>: ViewModifier where SignalPayload: Sendable, SignalPayload: Equatable {
    private let logger: Logger
    @Environment(\.signalLogLevel) private var minLogLevel: LogLevel

    @EnvironmentObject private var signalReference: Reference<Signal<SignalPayload>?>
    @State private var lastReceivedSignal: Signal<SignalPayload>?
    private let handler: SignalHandler<SignalPayload>

    init (
        fileId: String,
        line: Int,
        handler: @escaping SignalHandler<SignalPayload>
    ) {
        self.handler = handler
        self.logger = .init(name: "onSignal", fileId: fileId, line: line)
    }

    func body (content: Content) -> some View {
        content
            .onChange(of: signalReference.referencedValue) {
                handle($0, "onChange")
            }
            .onAppear {
                handle("onAppear")
            }
    }

    private func handle (_ source: String) {
        handle(signalReference.referencedValue, source)
    }

    private func handle (_ signal: Signal<SignalPayload>?, _ source: String) {
        guard let signal = signal else {
            logger.log(
                .notice,
                source,
                "nil signal",
                Signal<SignalPayload>?.none,
                minLevel: minLogLevel
            )
            return
        }

        if signal.id == lastReceivedSignal?.id {
            logger.log(
                .notice,
                source,
                "Duplicated signal",
                signal,
                minLevel: minLogLevel
            )
            return
        }

        if signal.status.isProcessing {
            logger.log(
                .debug,
                source,
                "Processing signal",
                signal,
                minLevel: minLogLevel
            )
            return
        }

        if signal.status.isCompleted {
            logger.log(
                .debug,
                source,
                "Completed signal",
                signal,
                minLevel: minLogLevel
            )
            return
        }

        lastReceivedSignal = signal

        logger.log(
            .debug,
            source,
            "Signal handling started - environment state",
            signalReference.referencedValue,
            minLevel: minLogLevel
        )

        let processingSignal = signal.setStatus(.processing)
        signalReference.referencedValue = processingSignal

        logger.log(
            .info,
            source,
            "Signal handling started",
            processingSignal,
            minLevel: minLogLevel
        )

        Task {
            try? await Task.sleep(nanoseconds: 100_000_000)

            let (processingAction, signalPayload) = await handle(signal)

            if lastReceivedSignal?.id == signal.id, lastReceivedSignal?.payload != signalPayload {
                lastReceivedSignal = nil
            }

            let handledSignal = Signal<SignalPayload>(
                id: signal.id,
                status: processingAction.signalStatus,
                payload: signalPayload
            )

            logger.log(
                .debug,
                source,
                "Handled signal - environment state",
                signalReference.referencedValue,
                minLevel: minLogLevel
            )

            signalReference.referencedValue = handledSignal

            logger.log(
                .info,
                source,
                "Handled signal",
                handledSignal,
                minLevel: minLogLevel
            )
        }
    }

    private func handle (_ signal: Signal<SignalPayload>) async -> (ProcessingAction, SignalPayload) {
        do {
            return try await handler(signal)
        } catch {
            return (.fail(error), signal.payload)
        }
    }
}
