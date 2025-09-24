import Testing
import Foundation
@testable import BLESim

@Test func testInitialisation() async throws {
    let sim = BLESim(configuration: BLESim.Configuration(
            serviceUUID: UUID().uuidString,
            characteristicUUID: UUID().uuidString,
            localName: "Testing Device",
            logsEnabled: true
        )
    )
}
