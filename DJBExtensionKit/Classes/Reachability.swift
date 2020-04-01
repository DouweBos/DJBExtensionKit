//
//  Reachability.swift
//  DJBExtensionKit
//
//  Created by Douwe Bos on 23/03/2020.
//

import Foundation
import SystemConfiguration
import SystemConfiguration.CaptiveNetwork

public struct Reachability {
    public enum ReachabilityStatus {
        case notReachable
        case reachableViaWWAN
        case reachableViaWiFi
        
        public var stringRepresentation: String {
            get {
                switch self {
                case .notReachable:
                    return "not_connected"
                case .reachableViaWiFi:
                    return "wifi"
                case .reachableViaWWAN:
                    return "cellular"
                }
            }
        }
    }

    public static var currentReachabilityStatus: ReachabilityStatus {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return .notReachable
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return .notReachable
        }
        
        if flags.contains(.reachable) == false {
            // The target host is not reachable.
            return .notReachable
        }
        else if flags.contains(.isWWAN) == true {
            // WWAN connections are OK if the calling application is using the CFNetwork APIs.
            return .reachableViaWWAN
        }
        else if flags.contains(.connectionRequired) == false {
            // If the target host is reachable and no connection is required then we'll assume that you're on Wi-Fi...
            return .reachableViaWiFi
        }
        else if (flags.contains(.connectionOnDemand) == true || flags.contains(.connectionOnTraffic) == true) && flags.contains(.interventionRequired) == false {
            // The connection is on-demand (or on-traffic) if the calling application is using the CFSocketStream or higher APIs and no [user] intervention is needed
            return .reachableViaWiFi
        }
        else {
            return .notReachable
        }
    }

    public static var wifiSSID: String? {
        guard Reachability.currentReachabilityStatus == .reachableViaWiFi else { return nil }

        guard let interfaces = CNCopySupportedInterfaces() as? [String] else { return nil }
        let key = kCNNetworkInfoKeySSID as String
        for interface in interfaces {
            guard let interfaceInfo = CNCopyCurrentNetworkInfo(interface as CFString) as NSDictionary? else { continue }
            return interfaceInfo[key] as? String
        }
        return nil
    }

    public static var wifiEnabled: Bool {
        return Reachability.currentReachabilityStatus == .reachableViaWiFi
    }

    public static func openWifiSettings() {
        URL(string: UIApplication.openSettingsURLString).also {
            UIApplication.shared.open($0)
        }
    }

    public static func toggleWifi() {
        openWifiSettings()
    }
}
