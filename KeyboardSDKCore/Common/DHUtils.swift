//
//  DHUtils.swift
//  KeyboardSDKCore
//
//  Created by DHUtils on 2021/05/10.
//

import Foundation
import UIKit



/// 전역적으로 사용할 유틸리티성 기능을 모아둔 클래스
public class DHUtils {
    
    /// 전체 접근 허용여부를 확인하는 함수. Keyboard Extension에서 사용해야 정확한 결과값이 리턴된다.
    /// - Returns: 전체 접근을 허용한 경우 true를 반환한다.
    public static func isOpenAccessGranted() -> Bool{
        let pasted = UIPasteboard.general.string
        if pasted?.isEmpty ?? true {
//            UIPasteboard.general.string = "CHECK"
        }
        
        return UIPasteboard.general.hasStrings
    }
    
    /// 키보드를 사용하는 것으로 활성화 시켰는지 여부를 확인한다.
    /// - Returns: 키보드를 활성화 시킨 경우 true, 그 외의 경우 false
    public static func isKeyboardExtensionEnabled() -> Bool {
        
        guard let appBundleIdentifier = Bundle.main.bundleIdentifier else {
            DHLogger.log("isKeyboardExtensionEnabled(): Cannot retrieve bundle identifier.")
            return false
        }
        
        guard let keyboards = UserDefaults.standard.dictionaryRepresentation()["AppleKeyboards"] as? [String] else {
            // There is no key `AppleKeyboards` in NSUserDefaults. That happens sometimes.
            return false
        }
        
        let keyboardExtensionBundleIdentifierPrefix = appBundleIdentifier + "."
        for keyboard in keyboards {
            if keyboard.hasPrefix(keyboardExtensionBundleIdentifierPrefix) {
                return true
            }
        }
        
        return false
    }
    
    
    public static func getAddress(for network: ENNetwork) -> String? {
        var address: String = ""

        // Get list of all interfaces on the local machine:
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return nil }
        guard let firstAddr = ifaddr else { return nil }

        // For each interface ...
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee

            // Check for IPv4 or IPv6 interface:
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {

                // Check interface name:
//                let name = String(cString: interface.ifa_name)
//                if name == network.rawValue {
//
//                    // Convert interface address to a human readable string:
//                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
//                    getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
//                                &hostname, socklen_t(hostname.count),
//                                nil, socklen_t(0), NI_NUMERICHOST)
//                    address = String(cString: hostname)
//                }
                
                let name = String(cString: interface.ifa_name)
                var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len), &hostname, socklen_t(hostname.count), nil, socklen_t(0), NI_NUMERICHOST)
                address = "\(address) ## \(name) : \(String(cString: hostname))"
                
            }
        }
        freeifaddrs(ifaddr)

        return address
    }
    
    public static func getNowDateToString() -> String {
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        return formatter.string(from: now)
    }
    
}

public enum ENNetwork: String {
    case wifi = "en0"
    case cellular = "pdp_ip0"
    //... case ipv4 = "ipv4"
    //... case ipv6 = "ipv6"
}
