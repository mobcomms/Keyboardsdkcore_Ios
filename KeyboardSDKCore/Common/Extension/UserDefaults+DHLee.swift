//
//  UserDefaults+DHLee.swift
//  DHCommonUtil
//
//  Created by DHLee on 2021/04/27.
//

import Foundation


/// UserDefaults 객체에서 사용할 key 값들
public struct DHUserDefaultsConstants: RawRepresentable {
    public var rawValue: String
    
    static let suiteName = DHUserDefaultsConstants(rawValue: "UserDefaults_Enliple_Keyboard_SDK_2021__")
    
    static let keyForFirstRun = DHUserDefaultsConstants(rawValue: "FirstRun")
    
    
    /// 키 값을 string value로 변경하여 반환한다.
    public var value: String {
        if self == .suiteName {
            return self.rawValue
        }
        else {
            return "\(DHUserDefaultsConstants.suiteName.rawValue)\(self.rawValue)"
        }
    };
    
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
    
}


public extension UserDefaults {
    
    /// 본 프로젝트에서 사용할 UserDefaults 객체
    static let enKeyboardStandard = UserDefaults.init(suiteName: DHUserDefaultsConstants.suiteName.value)
    
    
    /// - Returns:
    
    /**
     값을 가져오는 것에 대한 샘플 (삭제 예정)
     
     - returns 저장된 샘플 값.
     
     @available(1.0, deprecated:1.0, message: 삭제예정)
     
     */

    func isFirstRun() -> Bool {
        return !(UserDefaults.enKeyboardStandard?.bool(forKey: DHUserDefaultsConstants.keyForFirstRun.value) ?? false)
    }
    
    
    /**
     값 저장에 대한 샘픔 (삭제 예정)
     @available(1.0, deprecated:1.0, message: 삭제예정)
     */
    func setFirstRun() {
        UserDefaults.enKeyboardStandard?.setValue(true, forKey: DHUserDefaultsConstants.keyForFirstRun.value)
        UserDefaults.enKeyboardStandard?.synchronize()
    }
    
}
