import Combine

nonisolated class Buffer <Element>: ObservableObject {
    let bufferSize: Int?
    var buffer = [Element]()

    init (bufferSize: Int?) {
        self.bufferSize = bufferSize
    }

    func add (_ element: Element) {
        buffer.append(element)

        dropOverflow()
    }

    func next () -> Element? {
        guard buffer.count > 0 else { return nil }
        return buffer.removeFirst()
    }

    private func dropOverflow () {
        guard let bufferSize else { return }

        if bufferSize > 0 {
            let overflow = buffer.count - bufferSize

            if overflow > 0 {
                buffer.removeFirst(overflow)
            }
        } else {
            buffer = []
        }
    }
}
