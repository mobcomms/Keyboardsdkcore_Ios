//
//  UIColor+DHLee.swift
//  DHCommonUtil
//
//  Created by DHLee on 2021/05/03.
//

import UIKit


extension UIColor {

    
    /// argb int 값을 전달받아 UIColor를 생성한다.
    /// - Parameters:
    ///   - alpha: 색상 alpha값. 0~255
    ///   - red: 색상 red값. 0~255
    ///   - green: 색상 green값. 0~255
    ///   - blue: 색상 blue값. 0~255
    convenience init(alpha:Int64, red: Int64, green: Int64, blue: Int64) {
        assert(alpha >= 0 && alpha <= 255, "Invalid Alpha component")
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: CGFloat(alpha) / 255.0)
    }
    
    
    /// 16진수 argb값을 통해 UIColor를 생성한다.
    /// - Parameter argb: 16진수 argb값  0x00000000 ~ 0xFFFFFFFF
    convenience init(argb: Int64) {
        self.init(
            alpha: (argb >> 24) & 0xFF,
            red: (argb >> 16) & 0xFF,
            green: (argb >> 8) & 0xFF,
            blue: argb & 0xFF
        )
    }
    
    
    /// rgb int 값을 전달받아 UIColor를 생성한다.
    /// - Parameters:
    ///   - r: 색상 red값. 0~255
    ///   - g: 색상 green값. 0~255
    ///   - b: 색상 blue값. 0~255
    convenience init(r: Int, g: Int, b: Int) {
        self.init(r:r, g:g, b:b, a:255)
    }
    
    /// rgba int 값을 전달받아 UIColor를 생성한다.
    /// - Parameters:
    ///   - r: 색상 red값. 0~255
    ///   - g: 색상 green값. 0~255
    ///   - b: 색상 blue값. 0~255
    ///   - a: 색상 alpha값. 0~255
    convenience init(r: Int, g: Int, b: Int, a:Int) {
        self.init(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: CGFloat(a)/255.0)
    }
    
    
    /// 현재 색상값을 이용하여 이미지를 생성한다
    /// - Returns: 현재 색상값을 기반으로 만들어진 이미지를 반환한다.  실패시 nil을 반환한다.
    func toImage() -> UIImage? {
        
        let rect = CGRect.init(x:0, y:0, width:1, height:1)
        UIGraphicsBeginImageContext(rect.size)
        
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(self.cgColor)
        context?.fill(rect)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    
    /// Hex String으로 전달받은 값을 이용하여 UIColor를 생성한다.
    /// - Parameter hexString: 색상값에 대응하는 Hex String. 3자리, 6자리, 8자리 값으로 입력이 가능하다.  ex) #FFF, #FFFFFF, #FFFFFFFF
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    
    func toHexString() -> String {
        guard let components = self.cgColor.components, components.count > 1 else {
            return "#00FFFFFF"
        }
        if components.count == 2 {
            let w: CGFloat = components[0]
            let a: CGFloat = components[1]
            
            let hexString = String.init(format: "#%02lX%02lX%02lX%02lX", lroundf(Float(a * 255)), lroundf(Float(w * 255)), lroundf(Float(w * 255)), lroundf(Float(w * 255)))
            return hexString
        }
        else {
            let r: CGFloat = components[0]
            let g: CGFloat = components[1]
            let b: CGFloat = components[2]
            var a: CGFloat = 1.0
            
            if components.count > 3 {
               a = components[3]
            }
            
            let hexString = String.init(format: "#%02lX%02lX%02lX%02lX", lroundf(Float(a * 255)), lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
            return hexString
        }
     }
    
    // MARK: 색상이 밝은지 밝지 않은지 구분 / 추가 된 날짜 : 2023 08 14 / xim
    /// 해당 색상이 밝은지 어두운지 판별함.
    /// - Parameter threshold: 이 값이 높을 수록 밝다 라는 기준이 높아짐
    /// - Returns 밝으면 true, 밝지 않으면 false
    func isLight(threshold: Float = 0.5) -> Bool {
        let originalCGColor = self.cgColor
        let rgbCGColor = originalCGColor.converted(to: CGColorSpaceCreateDeviceRGB(), intent: .defaultIntent, options: nil)
        
        guard let components = rgbCGColor?.components, components.count >= 3 else {
            return true
        }
        
        let brightness = Float(((components[0] * 299) + (components[1] * 587) + (components[2] * 114)) / 1000)
        return (brightness > threshold)
    }
}
