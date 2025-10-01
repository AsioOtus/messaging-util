import SwiftUI

struct OnSignalViewModifier <SignalPayload>: ViewModifier where SignalPayload: Sendable {
    private let logger: Logger
    @Environment(\.signalLogLevel) private var minLogLevel: LogLevel

    @EnvironmentObject private var signalReference: Reference<Signal<SignalPayload>?>
    @State private var lastReceivedSignalId: String?
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
                handle($0)
            }
            .onAppear {
                handle()
            }
    }

    private func handle () {
        handle(signalReference.referencedValue)
    }

    private func handle (_ signal: Signal<SignalPayload>?) {
        guard let signal = signal else {
            logger.log(
                .notice,
                "nil signal",
                Signal<SignalPayload>?.none,
                minLevel: minLogLevel
            )
            return
        }

        if signal.id == lastReceivedSignalId {
            logger.log(
                .notice,
                "Duplicated signal",
                signal,
                minLevel: minLogLevel
            )
            return
        }

        if signal.status.isProcessing {
            logger.log(
                .debug,
                "Processing signal",
                signal,
                minLevel: minLogLevel
            )
            return
        }

        if signal.status.isCompleted {
            logger.log(
                .debug,
                "Completed signal",
                signal,
                minLevel: minLogLevel
            )
            return
        }

        lastReceivedSignalId = signal.id

        let processingSignal = signal.setStatus(.processing)
        signalReference.referencedValue = processingSignal

        logger.log(
            .info,
            "Signal handling started",
            processingSignal,
            minLevel: minLogLevel
        )

        Task {
            let (processingAction, signalPayload) = await handle(signal)

            let handledSignal = Signal<SignalPayload>(
                id: signal.id,
                status: processingAction.signalStatus,
                payload: signalPayload
            )

            signalReference.referencedValue = handledSignal

            logger.log(
                .info,
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
