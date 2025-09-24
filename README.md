# BLESim

A lightweight Swift package to **simulate a Bluetooth Low Energy (BLE) peripheral** on **iOS** or **macOS**.  
Easily broadcast any binary payload as BLE characteristic notifications—perfect for prototyping or testing without dedicated hardware.

---

## Features
- **Cross-platform**: iOS & macOS (CoreBluetooth).
- **Generic Data**: Send any `Data` object (JSON, binary structs, strings…).
- **Drop-in Ready**: Add via Swift Package Manager and start advertising in minutes.

---

## Installation

### Swift Package Manager (SPM)
1. In Xcode: `File ▸ Add Packages…`
2. ADD ```
https://github.com/saqibomer/BLESim)
```
3. Add **BLESim** to your target.
   Or in a `Package.swift`:
```swift
dependencies: [
 .package(url: "https://github.com/saqibomer/BLESim", from: "1.0.0")
]
```

## Quick Start
```bash
import BLESim

let peripheral = BLESim(configuration: BLESim.Configuration(
            serviceUUID: UUID().uuidString,
            characteristicUUID: UUID().uuidString,
            localName: "Testing Device",
            logsEnabled: true
        )
    )
peripheral.startAdvertising()

// Send any data to subscribed centrals
let payload = Data("Hello BLE".utf8)
peripheral.send(payload)
```

Dont forget to add ```NSBluetoothAlwaysUsageDescription``` in Info.plist

## API Overview
| Method / Property      | Description                                     |
| ---------------------- | ----------------------------------------------- |
| `init(configuration:)` | Custom UUIDs, local name and logs setting       |
| `startAdvertising()`   | Starts BLE advertising.                         |
| `stopAdvertising()`    | Stops advertising.                              |
| `send(_ data: Data)`   | Sends a notification to subscribed centrals.    |
| `isAdvertising`        | Bool indicating advertising status.             |

## Contributing
Pull requests, issues, and feature suggestions are welcome!
Please open a discussion or issue before submitting major changes.

## License
MIT License – see [LICENSE](https://mit-license.org) for details.

