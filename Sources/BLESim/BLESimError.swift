//
//  BLESimError.swift
//  BLESim
//
//  Created by Saqib Omer on 24/09/2025.
//  GitHub: https://github.com/saqibomer
//
    


import Foundation

/// Errors that can be thrown or reported by BLESim.
public enum BLESimError: Error, LocalizedError {
    case invalidServiceId(String)
    case invalidCharcId(String)
    case unauthorized(String)
    case bluetoothUnavailable
    case advertisingFailed(String)
    case notPoweredOn

    public var errorDescription: String? {
        switch self {
        case .invalidServiceId(let s):
                    return "Invalid service Id: \(s)"
        case .invalidCharcId(let s):
                    return "Invalid characteristic: \(s)"
        case .unauthorized(let s):
                    return "Unathorised: \(s)"
        case .bluetoothUnavailable:
            return "Bluetooth is not available on this device."
        case .advertisingFailed(let reason):
            return "Failed to start advertising: \(reason)"
        case .notPoweredOn:
            return "Bluetooth is not powered on."
        }
    }
}
