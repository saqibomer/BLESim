import Testing
import Foundation
@testable import BLESim

@Test func testInitialisation() async throws {
    do {
        let config = try BLESim.Configuration(
            serviceUUID: "A3B2C1D0-EF12-3456-7890-ABCDEF012345",
            characteristicUUID: "180D"
        )
        let bleSim = BLESim(configuration: config)
        bleSim.startAdvertising()
    } catch {
        print("Configuration error: \(error.localizedDescription)")
        throw error
    }
}
