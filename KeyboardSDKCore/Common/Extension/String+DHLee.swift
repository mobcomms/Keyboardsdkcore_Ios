//
//  String+DHLee.swift
//  DHCommonUtil
//
//  Created by DHLee on 2021/04/29.
//

import Foundation

public extension String {
    
    /// Dictionary값을 받아 JSON String 형태로 변환한다.
    /// - Parameter dict: JSON String으로 변환할 Dictionary 값
    /// - Returns: 변환된 Dictionary 객체.  JSON String에 오류가 있는 경우 빈 Dictionary를 반환한다.
    static func from(dict: Dictionary<String, Any>) -> String {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict)
            return String(data: jsonData, encoding: .utf8) ?? ""
        }
        catch {
            return ""
        }
    }
    
    
    /// String을  Dictionary형태로 변환한 값.  JSON 타입에 맞춰서 변경되므로 포맷이 잘못되어 있는경우 비이었는 Dictionary를 반환한다.
    var dictionary: Dictionary<String, Any> {
        get {
            do {
                guard let data = self.data(using: .utf8),
                      let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? Dictionary<String, Any> else {
                    return Dictionary.init()
                }
                
                return json
            }
            catch {
                return Dictionary.init()
            }
        }
        
        set {
            self = String.from(dict: newValue)
        }
    }
    
    
    /// 지정된 폰트 및 view의 너비를 이용하는 경우 필요로하는 View의 최소 높이를 계산한다.
    /// - Parameters:
    ///   - width: view 너비
    ///   - font: 적용할 font
    /// - Returns: 필요로하는 view의 최소 높이값을 반환한다.
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    
    /// 지정된 폰트 및 view의 높이를 이용하는 경우 필요로하는 View의 최소 너비를 계산한다.
    /// - Parameters:
    ///   - height: view 높이
    ///   - font: 적용할 font
    /// - Returns: 필요로하는 view의 최소 너비값을 반환한다.
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
    
    
    /// 현재 텍스트를 이미지로 변환한다.
    /// - Parameters:
    ///   - width: 변경할 이미지 너비
    ///   - height: 변경할 이미지 높이
    /// - Returns: 지정된 크기로 변환된 이미지
    func image(width:CGFloat = 40, height:CGFloat = 40) -> UIImage? {
        let size = CGSize(width: width, height: height)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        
        UIColor.clear.set()
        let rect = CGRect(origin: .zero, size: size)
        UIRectFill(CGRect(origin: .zero, size: size))
        (self as AnyObject).draw(in: rect, withAttributes: [.font: UIFont.systemFont(ofSize: width-5)])
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        

        return image
    }
}
