//
//  CALayer+ENKeyboardSDK.swift
//  KeyboardSDK
//
//  Created by enlipleIOS1 on 2021/06/21.
//

import Foundation
import UIKit

extension CALayer {
    func applySketchShadow(
        color: UIColor = .black,
        alpha: Float = 0.64,
        x: CGFloat = 0,
        y: CGFloat = 8,
        blur: CGFloat = 16,
        spread: CGFloat = 5)
    {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
        if spread == 0 {
            shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
    
    
    func applyRounding(cornerRadius:CGFloat = 0.0, borderColor:UIColor = .clear, borderWidth:CGFloat = 1.0, masksToBounds:Bool = true) {
        self.cornerRadius = cornerRadius
        self.borderColor = borderColor.cgColor
        self.borderWidth = borderWidth
        self.masksToBounds = masksToBounds
    }
}
