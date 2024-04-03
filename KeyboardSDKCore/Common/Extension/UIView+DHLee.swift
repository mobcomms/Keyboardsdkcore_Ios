//
//  UIView+DHLee.swift
//  KeyboardSDKCore
//
//  Created by cashwalkKeyboard on 2021/07/08.
//

import Foundation


extension UIView {
    
    public func showEnToast(message : String, font: UIFont = UIFont.systemFont(ofSize: 14.0, weight: .regular), backgroundColor:UIColor = UIColor.black.withAlphaComponent(0.6)) {
        
        var needWidth = message.width(withConstrainedHeight: 1000, font: font) + 20
        if needWidth > self.frame.width {
            needWidth = self.frame.width - 60
        }
        
        var needHeight = message.height(withConstrainedWidth: needWidth - 20, font: font) + 10
        if needHeight < 30.0 {
            needHeight = 30.0
        }
        
        // needHeight + 120 이 getKeyboardHeight 의 가운데임...
        let temp = UIScreen.main.bounds.width > UIScreen.main.bounds.height ?
        ENSettingManager.shared.getKeyboardHeight(isLandcape: true) : ENSettingManager.shared.getKeyboardHeight(isLandcape: false)
        let toastLabel = DHPaddedLabel(frame: CGRect(x: (self.frame.size.width - needWidth) / 2.0, y: self.frame.size.height - (needHeight + (temp / 2.5)), width: needWidth, height: needHeight))
        toastLabel.backgroundColor = backgroundColor
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 15.0
        toastLabel.clipsToBounds = true
        toastLabel.numberOfLines = 0
        
        self.addSubview(toastLabel)
        
        UIView.animate(withDuration: 0.5, delay: 1.5, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        },
        completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
            
        })
    }

    
    
}
