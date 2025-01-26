import Foundation

@dynamicMemberLookup
public final class Reference <Value>: ObservableObject {
    public static func object (_ value: Value) -> Self {
        .init(value)
    }

    @Published public var referencedValue: Value

    public init (_ value: Value) {
        self.referencedValue = value
    }

    subscript <T> (dynamicMember keyPath: WritableKeyPath<Value, T>) -> T {
        referencedValue[keyPath: keyPath]
    }

    subscript <T> (dynamicMember keyPath: KeyPath<Value, T>) -> T {
        referencedValue[keyPath: keyPath]
    }
}
