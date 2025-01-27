import Foundation

struct Message <Content: Equatable>: Equatable {
    let id: UUID
    let status: MessageStatus
    let content: Content

    var info: MessageInfo {
        .init(
            id: id,
            status: status
        )
    }
}
