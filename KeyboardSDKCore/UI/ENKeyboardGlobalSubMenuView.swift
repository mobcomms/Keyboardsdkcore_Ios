//
//  ENKeyboardGlobalSubMenuView.swift
//  KeyboardSDKCore
//
//  Created by cashwalkKeyboard on 2021/05/24.
//

import Foundation
import UIKit


/// 키보드의 글로벌 버튼을 기렉 눌러 나타나는 서브 메뉴의 Action을 정의
public enum ENKeyboardGlobalSubMenuViewAction {
    case changeKeyboard
    case toEnglish
    case toKorean
}


/// ENKeyboardGlobalSubMenuViewDelegate
public protocol ENKeyboardGlobalSubMenuViewDelegate: AnyObject {
    func globalSubMenuTapped(menu:ENKeyboardGlobalSubMenuView, action:ENKeyboardGlobalSubMenuViewAction)
}



/// 키보드의 글로벌 버튼을 길게 눌러 나타나는 서브 메뉴를 보여주기 위한 뷰
public class ENKeyboardGlobalSubMenuView: UIView {
    
    public static let needSize: CGSize = CGSize(width: 120, height: 120)
    
    
    public weak var delegate: ENKeyboardGlobalSubMenuViewDelegate?
    
    private var nextKeyboardButton: UIButton? = nil
    private var engKeyboardButton: UIButton? = nil
    private var korKeyboardButton: UIButton? = nil
    
    private let sep1 = UIView()
    private let sep2 = UIView()
    
    private var contentView:UIView = UIView(frame: .zero)
        
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initView()
    }
    
    
    public init(frame: CGRect, theme:ENThemeColors) {
        super.init(frame: frame)
        initView(theme: theme)
    }
    
    private func initView(theme:ENThemeColors? = nil) {
        
        nextKeyboardButton = makeButton(title: "다음 키보드")
        engKeyboardButton = makeButton(title: "English")
        korKeyboardButton = makeButton(title: "한국어")
        
        nextKeyboardButton?.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
        engKeyboardButton?.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
        korKeyboardButton?.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
        
        contentView.addSubview(nextKeyboardButton!)
        contentView.addSubview(engKeyboardButton!)
        contentView.addSubview(korKeyboardButton!)
        
        contentView.addSubview(sep1)
        contentView.addSubview(sep2)
        
        
        nextKeyboardButton?.frame = CGRect(x: 0, y: 0, width: ENKeyboardGlobalSubMenuView.needSize.width, height: 40)
        engKeyboardButton?.frame = CGRect(x: 0, y: 41, width: ENKeyboardGlobalSubMenuView.needSize.width, height: 40)
        korKeyboardButton?.frame = CGRect(x: 0, y: 82, width: ENKeyboardGlobalSubMenuView.needSize.width, height: 40)
        sep1.frame = CGRect(x: 0, y: 40, width: ENKeyboardGlobalSubMenuView.needSize.width, height: 1)
        sep2.frame = CGRect(x: 0, y: 81, width: ENKeyboardGlobalSubMenuView.needSize.width, height: 1)
        
        
        
        contentView.layer.cornerRadius = 8.0
        contentView.layer.borderWidth = 0.0
        contentView.layer.borderColor = UIColor.cyan.cgColor
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = UIColor(red: 37/255, green: 46/255, blue: 51/255, alpha: 1)
        
        
        self.addSubview(contentView)
        self.backgroundColor = .clear
        self.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(buttonTapped(sender:))))
        self.isUserInteractionEnabled = true
        
        changeTheme(theme: theme)
    }
    
    
    func setContentFrame(contentFrame: CGRect) {
        self.contentView.frame = contentFrame
    }
    
    
    func changeTheme(theme:ENThemeColors? = nil) {
        let lineColor = theme?.tab_on ?? UIColor.white
        let textColor = theme?.key_text ?? UIColor.black
        let bgColor = theme?.tab_off ?? UIColor.white
        
        sep1.backgroundColor = lineColor
        sep2.backgroundColor = lineColor
        
        contentView.layer.borderColor = lineColor.cgColor
        
        nextKeyboardButton?.backgroundColor = UIColor(red: 79/255, green: 92/255, blue: 99/255, alpha: 1)
        nextKeyboardButton?.setTitleColor(.white, for: .normal)
        
        engKeyboardButton?.backgroundColor = UIColor(red: 79/255, green: 92/255, blue: 99/255, alpha: 1)
        engKeyboardButton?.setTitleColor(.white, for: .normal)
        
        korKeyboardButton?.backgroundColor = UIColor(red: 79/255, green: 92/255, blue: 99/255, alpha: 1)
        korKeyboardButton?.setTitleColor(.white, for: .normal)
    }
    
    
    func makeButton(title: String) -> UIButton {
        let button = UIButton(type: .custom)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13.0, weight: .medium)
        
        return button
    }
    
    
    @objc func buttonTapped(sender: UIButton) {
        switch sender {
        case nextKeyboardButton:
            delegate?.globalSubMenuTapped(menu: self, action: .changeKeyboard)
            break
            
        case engKeyboardButton:
            delegate?.globalSubMenuTapped(menu: self, action: .toEnglish)
            break
            
        case korKeyboardButton:
            delegate?.globalSubMenuTapped(menu: self, action: .toKorean)
            break
            
        default:
            self.removeFromSuperview()
            break
        }
    }
    
}
