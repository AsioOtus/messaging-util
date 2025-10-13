import Combine
import SwiftUI

struct SignalBroadcastViewModifier <SignalPayload, PayloadPublisher>: ViewModifier
where
SignalPayload: Sendable,
SignalPayload: Equatable,
PayloadPublisher: Publisher<SignalPayload, Never>
{
    private let logger: Logger
    @Environment(\.signalLogLevel) private var minLogLevel: LogLevel

    private let eventCompletionHandler: (Signal<SignalPayload>, Error?) -> Void
    private let payloadPublisher: PayloadPublisher
    
    @StateObject private var signal: Reference<Signal<SignalPayload>?> = .init(nil)

    init (
        payloadPublisher: PayloadPublisher,
        fileId: String,
        line: Int,
        eventCompletionHandler: @escaping (Signal<SignalPayload>, Error?) -> Void
    ) {
        self.eventCompletionHandler = eventCompletionHandler
        self.payloadPublisher = payloadPublisher
        self.logger = .init(name: "signalBroadcast", fileId: fileId, line: line)
    }

    func body (content: Content) -> some View {
        content
            .onReceive(payloadPublisher, perform: onNewSignal(payload:))
            .onChange(of: signal.referencedValue, perform: onSignalChanged)
            .environmentObject(signal)
    }

    private func onNewSignal (payload: SignalPayload) {
        let newId = String(UUID().uuidString.prefix(8))
        let signal = Signal(id: newId, status: .dispatching, payload: payload)

        handleNewSignal(signal)
    }

    private func handleNewSignal (_ signal: Signal<SignalPayload>) {
        logger.log(
            .trace,
            nil,
            "New signal",
            signal,
            minLevel: minLogLevel
        )

        if self.signal.referencedValue != nil && self.signal.referencedValue?.status.isCompleted == false {
            logger.log(
                .trace,
                nil,
                "Current signal interrupted",
                self.signal.referencedValue,
                minLevel: minLogLevel
            )

            self.signal.referencedValue = self.signal.referencedValue?.setStatus(.completed(InterruptedError()))
        }

        self.signal.referencedValue = signal
    }

    private func onSignalChanged (_ signal: Signal<SignalPayload>?) {
        if let signal, signal.status.isCompleted {
            logger.log(
                .trace,
                nil,
                "Signal completed",
                signal,
                minLevel: minLogLevel
            )

            eventCompletionHandler(signal, signal.status.error)
        }
    }
}

public extension View {
    func signalBroadcast <SignalPayload, SignalPayloadPublisher> (
        _ payloadPublisher: SignalPayloadPublisher,
        fileId: String = #fileID,
        line: Int = #line,
        onEventCompletion: @escaping (Signal<SignalPayload>, Error?) -> Void = { _, _ in }
    ) -> some View
    where
    SignalPayload: Sendable,
    SignalPayloadPublisher: Publisher<SignalPayload, Never>
    {
        modifier(
            SignalBroadcastViewModifier<SignalPayload, SignalPayloadPublisher>(
                payloadPublisher: payloadPublisher,
                fileId: fileId,
                line: line,
                eventCompletionHandler: onEventCompletion
            )
        )
    }
}
