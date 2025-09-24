//
//  BLESimStatus.swift
//  BLESim
//
//  Created by Saqib Omer on 24/09/2025.
//  GitHub: https://github.com/saqibomer
//
    


import Foundation

/// BLESim status.
public enum BLESimStatus: String {
    /// BLE peripheral not yet started or explicitly stopped.
    case stopped
    
    /// Waiting for the CBPeripheralManager to power on.
    case initializing
    
    /// Advertising is running and ready for centrals to discover.
    case advertising
    
    /// A central has connected **and** subscribed to the characteristic.
    case subscribed
    
    /// Bluetooth on the device is powered off.
    case poweredOff
    
    /// Bluetooth hardware not available or unsupported.
    case unavailable
    
    /// User denied Bluetooth permissions.
    case unauthorized
    
    /// An unexpected internal error occurred.
    case error
}
