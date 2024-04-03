//
//  ENKeyboardPreView.swift
//  KeyboardSDKCore
//
//  Created by cashwalkKeyboard on 2021/05/25.
//

import Foundation
import UIKit



/// 키보드 터치시 프리뷰를 보여주는 뷰
public class ENKeyboardPreView: UIView {
    
    var labelText:UILabel = UILabel(frame: .zero)
    var backgroundImageView:UIImageView = UIImageView.init(frame: .zero)
    
    var ownerView:UIView? = nil

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initView()
    }
    
    
    public init(frame: CGRect, theme:ENKeyboardTheme?) {
        super.init(frame: frame)
        initView(theme: theme)
    }
    
    private func initView(theme:ENKeyboardTheme? = nil) {
        backgroundImageView.contentMode = .scaleAspectFill
        
        self.addSubview(backgroundImageView)
        self.addSubview(labelText)

        backgroundImageView.topAnchor.constraint(equalTo: self.topAnchor ,constant:0).isActive = true
        backgroundImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor ,constant:0).isActive = true
        
        labelText.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        labelText.textAlignment = .center
        labelText.topAnchor.constraint(equalTo: backgroundImageView.topAnchor ,constant:0).isActive = true
        labelText.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor ,constant:0).isActive = true
        labelText.leadingAnchor.constraint(equalTo: backgroundImageView.leadingAnchor ,constant:0).isActive = true
        labelText.trailingAnchor.constraint(equalTo: backgroundImageView.trailingAnchor ,constant:0).isActive = true
        
        labelText.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        
        changeTheme(theme: theme)
    }
    
    func updateFrame(with:ENKeyButtonView?) {
        guard let button = with else {
            self.frame = .zero
            return
        }
        
        let btnFrame = button.frame
        let pFrame = button.superview?.frame ?? .zero
        let width = btnFrame.width
        let offset = 10.0

        let previewHeight = 50.0
        self.frame = CGRect(x: btnFrame.midX - (width / 2) - offset/2,
                            y: pFrame.origin.y - previewHeight + 5.0, 
                            width: width + offset,
                            height: previewHeight)
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true

        ownerView = with
    }
    
    func hidePreview(from:UIView?) {
        if ownerView == nil || from == ownerView {
            self.removeFromSuperview()
        }
    }
    
    
    func changeTheme(theme:ENKeyboardTheme? = nil) {
        backgroundImageView.image = theme?.previewBackgroundImage
        labelText.textColor = UIColor.black
    }
    
}
