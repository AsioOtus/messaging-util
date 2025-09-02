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

    func next () -> Element {
        buffer.removeFirst()
    }

    private func dropOverflow () {
        guard let bufferSize, bufferSize > 0 else { return }
        let overflow = buffer.count - bufferSize

        guard overflow > 0 else { return }
        buffer.removeFirst(overflow)
    }
}
