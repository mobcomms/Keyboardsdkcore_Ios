//
//  StringEncoding+DHLee.swift
//  DHCommonUtil
//
//  Created by DHLee on 2021/05/03.
//

import Foundation

public extension String.Encoding {
    
    /// EUC-KR 인코딩 타입
    static var eucKR:String.Encoding {
        let encodingEUCKR = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.EUC_KR.rawValue))
        
        return String.Encoding(rawValue: encodingEUCKR)
    }
    
}
