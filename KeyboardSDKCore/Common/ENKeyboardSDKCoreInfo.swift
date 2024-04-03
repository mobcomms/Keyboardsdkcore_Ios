//
//  ENKeyboardSDKCoreInfo.swift
//  KeyboardSDKCore
//
//  Created by enlipleIOS1 on 2021/04/27.
//

import Foundation


/// SDK Core의 버전 및 기타 정보를 담는 클래스
public class ENKeyboardSDKCoreInfo {
    
    
    /// SDK의 버전정보를 가져온다.
    public static var version: String {
        get {
            let ver = String(cString: KeyboardSDKCoreVersionStringPtr)
            
            guard let range = ver.range(of: "-") else {
                return ""
            }
            return String(ver[range.upperBound...]).replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "")
        }
    }
    
    
    
    /// 로그 메세지 출력 여부를 설정한다.
    static var showLog:Bool = true
    static var showTime:Bool = true

}

