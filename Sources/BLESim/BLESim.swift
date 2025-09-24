// The Swift Programming Language
// https://docs.swift.org/swift-book
import CoreBluetooth
import Foundation

/// A generic BLE peripheral simulator that can send any binary data
/// via notifications to subscribed centrals.
public final class BLESim: NSObject {
    
    // MARK: - Configuration
    public struct Configuration {
        public let serviceId: CBUUID
        public let characteristicId: CBUUID
        public let localName: String
        public let logsEnabled: Bool

        public init(serviceId: String,
                    characteristicId: String,
                    localName: String = "BLESim",
                    logsEnabled: Bool = false) throws
        {
            // Validate first using Foundation's UUID initializer
            guard UUID(uuidString: serviceId) != nil || serviceId.count == 4 else {
                throw BLESimError.invalidServiceId(serviceId)
            }
            guard UUID(uuidString: characteristicId) != nil || characteristicId.count == 4 else {
                throw BLESimError.invalidCharcId(characteristicId)
            }

            // Safe to create CBUUID now
            self.serviceId = CBUUID(string: serviceId)
            self.characteristicId = CBUUID(string: characteristicId)
            self.localName = localName
            self.logsEnabled = logsEnabled
        }
    }
    
    // MARK: - Public
    public var onSubscribed: ((_ peripheral: CBPeripheralManager) -> Void)?
    public var onDisconnect: ((_ peripheral: CBPeripheralManager) -> Void)?
    public var onError: ((BLESimError) -> Void)?
    public private(set) var isAdvertising: Bool = false
    
    // MARK: - Private
    private let config: Configuration
    private var manager: CBPeripheralManager!
    private var characteristic: CBMutableCharacteristic!
    
    // MARK: - Init
    public init(configuration: Configuration) {
        self.config = configuration
        super.init()
        manager = CBPeripheralManager(delegate: self, queue: nil)
    }
    
    // MARK: - Public API
    public func startAdvertising() {
        
        switch manager.state {
        case .unknown:
            onError?(.bluetoothUnavailable)
        case .resetting:
            return
        case .unsupported:
            onError?(.bluetoothUnavailable)
        case .unauthorized:
            onError?(.unauthorized("Permission to access bluetooht not granted"))
        case .poweredOff:
            onError?(.notPoweredOn)
        case .poweredOn:
            start()
        default:
            return
        }
        
    }
    
    public func stopAdvertising() {
        manager.stopAdvertising()
        isAdvertising = false
        if config.logsEnabled { print("[BLESim] Advertising stopped") }
    }
    
    /// Send arbitrary data to all subscribed centrals.
    @discardableResult
    public func send(_ data: Data) -> Bool {
        guard let char = characteristic else { return false }
        let ok = manager.updateValue(data, for: char, onSubscribedCentrals: nil)
        if config.logsEnabled { print("[BLESim] Sent \(data.count) bytes: \(ok)") }
        return ok
    }
    
    // MARK: - Private
    private func start() {
        let service = CBMutableService(type: config.serviceId, primary: true)
        characteristic = CBMutableCharacteristic(
            type: config.characteristicId,
            properties: [.notify],
            value: nil,
            permissions: []
        )
        service.characteristics = [characteristic]
        manager.add(service)
        manager.startAdvertising([
            CBAdvertisementDataServiceUUIDsKey: [config.serviceId],
            CBAdvertisementDataLocalNameKey: config.localName
        ])
        isAdvertising = true
        if config.logsEnabled { print("[BLESim] Advertising started as \(config.localName)") }
    }
}

// MARK: - CBPeripheralManagerDelegate
extension BLESim: CBPeripheralManagerDelegate {
    public func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if config.logsEnabled { print("[BLESim] State: \(peripheral.state.rawValue)") }
        if peripheral.state == .poweredOn, isAdvertising == false {
            start()
        }
    }

    public func peripheralManager(_ peripheral: CBPeripheralManager,
                                  central: CBCentral,
                                  didSubscribeTo characteristic: CBCharacteristic) {
        onSubscribed?(peripheral)
        if config.logsEnabled { print("[BLESim] Central subscribed: \(central.identifier)") }
    }

    public func peripheralManager(_ peripheral: CBPeripheralManager,
                                  central: CBCentral,
                                  didUnsubscribeFrom characteristic: CBCharacteristic) {
        onDisconnect?(peripheral)
        if config.logsEnabled { print("[BLESim] Central unsubscribed: \(central.identifier)") }
    }
}

