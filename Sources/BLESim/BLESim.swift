// The Swift Programming Language
// https://docs.swift.org/swift-book
import CoreBluetooth
import Foundation

/// A generic BLE peripheral simulator that can send any binary data
/// via notifications to subscribed centrals.
public final class BLESim: NSObject {
    
    public struct Configuration {
        public let serviceUUID: CBUUID
        public let characteristicUUID: CBUUID
        public let localName: String
        public let logsEnabled: Bool
        public init(
            serviceUUID: String = UUID().uuidString,
            characteristicUUID: String = UUID().uuidString,
            localName: String = "BLE-Sim",
            logsEnabled: Bool = false
        ) {
            self.serviceUUID = CBUUID(string: serviceUUID)
            self.characteristicUUID = CBUUID(string: characteristicUUID)
            self.localName = localName
            self.logsEnabled = logsEnabled
        }
    }
    
    private let config: Configuration
    private var manager: CBPeripheralManager!
    private var characteristic: CBMutableCharacteristic!
    
    public private(set) var isAdvertising: Bool = false
    
    public init(configuration: Configuration = Configuration()) {
        self.config = configuration
        super.init()
        manager = CBPeripheralManager(delegate: self, queue: nil)
    }
    
    /// Start advertising as a peripheral once Bluetooth is powered on.
    public func startAdvertising() {
        guard manager.state == .poweredOn else { return }
        start()
    }
    
    /// Stop advertising.
    public func stopAdvertising() {
        manager.stopAdvertising()
        isAdvertising = false
    }
    
    /// Send arbitrary data to subscribed centrals.
    /// Returns `true` if successfully queued for delivery.
    @discardableResult
    public func send(_ data: Data) -> Bool {
        guard let characteristic = characteristic else { return false }
        return manager.updateValue(data,
                                   for: characteristic,
                                   onSubscribedCentrals: nil)
    }
    
    private func start() {
        let service = CBMutableService(type: config.serviceUUID, primary: true)
        
        characteristic = CBMutableCharacteristic(
            type: config.characteristicUUID,
            properties: [.notify],
            value: nil,
            permissions: []
        )
        
        service.characteristics = [characteristic]
        manager.add(service)
        
        manager.startAdvertising([
            CBAdvertisementDataServiceUUIDsKey: [config.serviceUUID],
            CBAdvertisementDataLocalNameKey: config.localName
        ])
        isAdvertising = true
        
        if self.config.logsEnabled {
            print("Central started successfully")
        }
    }
}

// MARK: - CBPeripheralManagerDelegate
extension BLESim: CBPeripheralManagerDelegate {
    public func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if peripheral.state == .poweredOn, isAdvertising == false {
            start()
        }
    }
    
    public func peripheralManager(_ peripheral: CBPeripheralManager,
                                  central: CBCentral,
                                  didSubscribeTo characteristic: CBCharacteristic) {
        if self.config.logsEnabled {
            print("Central subscribed: \(central)")
        }
        
    }
    
    public func peripheralManager(_ peripheral: CBPeripheralManager,
                                  central: CBCentral,
                                  didUnsubscribeFrom characteristic: CBCharacteristic) {
        if self.config.logsEnabled {
            print("Central unsubscribed: \(central)")
        }
    }
}
