//
//  UIImage+DHLee.swift
//  DHCommonUtil
//
//  Created by DHLee on 2021/05/12.
//

import Foundation
//import UIKit

extension UIImage {
    
    
    /// 지정된 비율로 이미지 크기를 변경하여 반환한다.
    /// - Parameter scale: 변경하고자 하는 비율
    /// - Returns: 지정된 비율로 크기가 변경된 이미지.  오류 발생시 nil이 반환된다.
    public func resizedBy(scale:CGFloat) -> UIImage? {
        let newSize = CGSize.init(width: self.size.width * scale, height: self.size.height * scale)
        
        return UIGraphicsImageRenderer(size: newSize).image { _ in
            draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
    
    public func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
        let size = image.size
            
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
            
        // 비율에 맞게, 사각형의 형태 (가로 또는 높이 어떤게 긴 형태의 사각형인지) 에 따라 CGSize 생성
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
            
        // 생성한 CGSize 로 CGRect 생성
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
            
        // 리사이징 된 사이즈를 ImageContext 로 생성
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }

    
    
    /// 이미지에 padding을 추가한다.
    /// - Parameter indset: padding 사이즈
    /// - Returns: padding이 추가된 이미지
    func paddedBy(indset:UIEdgeInsets) -> UIImage {
        return self.withAlignmentRectInsets(indset)
        
//        let insets = UIEdgeInsets.init(top: 2.5, left: 2.5, bottom: 2.5, right: 2.5)
//        UIGraphicsBeginImageContextWithOptions(CGSize(width: self.size.width + insets.left + insets.right,
//                                                      height: self.size.height + insets.top + insets.bottom),
//                                               false,
//                                               self.scale)
//        let _ = UIGraphicsGetCurrentContext()
//        let origin = CGPoint(x: insets.left, y: insets.top)
//        self.draw(at: origin)
//        let imageWithInsets = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return imageWithInsets ?? self
    }
    
    
    /// 투명도 값이 적용된 이미지를 생성한다.
    /// - Parameter alpha: 적용할 투명도 0.0 ~ 1.0
    /// - Returns: 투명도가 적용된 이미지.  오류 발생시 nil을 반환한다.
    func image(alpha: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        
        draw(at: .zero, blendMode: .normal, alpha: alpha)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    // MARK: 이미지에서 특정 부분의 색상 가져오기 / 추가 된 날짜 : 2023 08 14 / xim
    /// 이미지에서 해당 point 의 pixel 의 색상을 가져온다.
    ///  - Parameter pos: 이미지에서 가져 올 위치
    ///  - Returns: 가져온 색상의 UIColor
    func getPixelColor(pos: CGPoint) -> UIColor {
        let pixelData = self.cgImage?.dataProvider?.data
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
        let pixelInfo: Int = ((Int(self.size.width) * Int(pos.y)) + Int(pos.x)) * 4
        
        let r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
        let g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
        let b = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
        let a = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)
        
        let tempColor = UIColor(red: r, green: g, blue: b, alpha: a)

        return tempColor
    }
}
