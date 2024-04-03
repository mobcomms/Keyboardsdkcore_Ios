//
//  Dictionary+DHLee.swift
//  DHCommonUtil
//
//  Created by DHLee on 2021/04/29.
//

import Foundation


public extension Dictionary {
    
    /// JSON String값을 받아 Dictionary 형태로 변환한다.
    /// - Parameter jsonString: Dictionary로 변환할 JSON String 값
    /// - Returns: 변환된 Dictionary 객체.  JSON String에 오류가 있는 경우 빈 Dictionary를 반환한다.
    static func from(jsonString: String) -> Dictionary {
        do {
            guard let data = jsonString.data(using: .utf8),
                  let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? Dictionary else {
                return Dictionary.init()
            }
            
            return json
        }
        catch {
            return Dictionary.init()
        }
    }
    
    
    /// Dictionary를 json string 형태로 변환한 값.
    var jsonString:String {
        get {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: self)
                return String(data: jsonData, encoding: .utf8) ?? ""
            }
            catch {
                return ""
            }
        }
        
        set {
            self = Dictionary.from(jsonString: newValue)
        }
    }
}
