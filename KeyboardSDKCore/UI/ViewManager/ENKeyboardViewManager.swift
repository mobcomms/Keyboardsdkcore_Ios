//
//  ENKeyboardViewManager.swift
//  KeyboardSDK
//
//  Created by cashwalkKeyboard on 2021/06/07.
//

import Foundation
import UIKit


import SwiftUI


public protocol ENKeyboardViewManagerDelegate: AnyObject {
    func enKeyboardViewManager(_ delegate:ENKeyboardViewManager, restoreToKeyboard:Bool)
}

public class ENKeyboardViewManager {
    
    lazy var keyboardView: UIView = UIView()
    
    public lazy var notifyView: UIView = {
        let notify = UIView()
        notify.backgroundColor = UIColor.init(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.0)
        
        return notify
    }()
    
    public lazy var customView: UIView = {
        let custom = UIView()
        custom.backgroundColor = UIColor.init(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.0)
        
        return custom
    }()
    
    public lazy var keyboardAreaView: UIView = {
        let custom = UIView()
        custom.backgroundColor = .clear
        
        return custom
    }()
    
    lazy var stackView1: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.spacing = 0
        stack.alignment = .fill
        return stack
    }()
    
    lazy var stackView2: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.spacing = 0
        stack.alignment = .fill

        return stack
    }()
    
    lazy var stackView3: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.spacing = 0
        stack.alignment = .fill
        return stack
    }()
    
    lazy var stackView4: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.spacing = 5
        stack.alignment = .fill
        return stack
    }()
    
    lazy var stackView5: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.spacing = 0
        stack.alignment = .fill
        return stack
    }()
    
    let backgroundImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let shadowView:UIView = {
        let shadow = UIView()
        shadow.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
        
        return shadow
    }()
    
    public var keyboardManager: ENKeyboardManager?
    public weak var delegate:ENKeyboardViewManagerDelegate? = nil
    public var isUseNotifyView: Bool = true
    
    var timer: Timer?
    let timeInterval: CGFloat = 3.0
    
    public var keyboardTheme: ENKeyboardTheme = ENKeyboardTheme() {
        didSet {
            backgroundImageView.image = keyboardTheme.backgroundImage
            if keyboardTheme.isPhotoTheme {
                backgroundImageView.alpha = keyboardTheme.imageAlpha
            }
            else {
                backgroundImageView.alpha = 1.0
            }
            
            keyboardManager?.keyboardTheme = keyboardTheme
        }
    }
    
    public var customTextField:UITextField? = nil {
        didSet {
            keyboardManager?.customTextField = customTextField
            emojiView?.customTextField = customTextField
        }
    }
    
    public var isLand:Bool = false {
        didSet {
            loadKeyboardManager(self.needsInputModeSwitchKey)
            updateConstraints()
            updateKeys()
        }
    }
    
    public var heightConstraint:NSLayoutConstraint?
    public var keyboardHeightConstraint:NSLayoutConstraint?
    
    public var notifyHeightConstraint: NSLayoutConstraint?
    
    public var proxy:UITextDocumentProxy? = nil
    
    var emojiView:ENEmojiView? = nil
    var needsInputModeSwitchKey:Bool = false
    
    var customContentView:UIView = UIView()
    var customContentSubView:UIView? = nil
    
    var customContentLayoutConstraint:[NSLayoutConstraint] = []
    
    public init(proxy:UITextDocumentProxy?, needsInputModeSwitchKey:Bool) {
        self.proxy = proxy
        self.needsInputModeSwitchKey = needsInputModeSwitchKey
        
        loadKeyboardManager(needsInputModeSwitchKey)
        
    }

    
    public func loadKeyboardManager(_ needsInputModeSwitchKey:Bool) {
        
        keyboardManager?.unloadKeyboard()
        (keyboardManager as? EN10KeyManager)?.unloadKeyboard()
        
        let delegate = keyboardManager?.delegate
        
        if isLand {
            loadQwertyManager()
        }
        else {
            switch ENSettingManager.shared.keyboardType {
            case .tenkey:
                    keyboardManager = EN10KeyManager.init(with: proxy, needsInputModeSwitchKey: needsInputModeSwitchKey)
                    keyboardManager?.stackView1 = stackView1
                    keyboardManager?.stackView2 = stackView2
                    keyboardManager?.stackView3 = stackView3
                    keyboardManager?.stackView4 = stackView4
                    keyboardManager?.stackView5 = stackView5
                    stackView1.axis = .vertical
                    stackView2.axis = .vertical
                    stackView3.axis = .vertical
                    stackView4.axis = .vertical
                    stackView5.axis = .vertical
                    
                    stackView1.spacing = 1
                    stackView2.spacing = 1
                    stackView3.spacing = 1
                    stackView4.spacing = 1
                    stackView5.spacing = 1
                
                break
                
            default:
                loadQwertyManager()
                break
            }
        }
        
        keyboardManager?.delegate = delegate
        func loadQwertyManager() {
            keyboardManager = ENQwertyManager.init(with: proxy, needsInputModeSwitchKey: needsInputModeSwitchKey)
            keyboardManager?.stackView1 = stackView1
            keyboardManager?.stackView2 = stackView2
            keyboardManager?.stackView3 = stackView3
            keyboardManager?.stackView4 = stackView4
            stackView1.axis = .horizontal
            stackView2.axis = .horizontal
            stackView3.axis = .horizontal
            stackView4.axis = .horizontal
            stackView5.axis = .horizontal
            stackView4.spacing = 5
        }
    }
    
    public func loadKeyboardView() -> UIView {
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.image = keyboardTheme.backgroundImage
        if keyboardTheme.isPhotoTheme {
            backgroundImageView.alpha = keyboardTheme.imageAlpha
        }
        else {
            backgroundImageView.alpha = 1.0
        }
        
        customView.isUserInteractionEnabled = true
        
        keyboardView.addSubview(backgroundImageView)
        keyboardView.addSubview(customView)
        keyboardView.addSubview(keyboardAreaView)
        keyboardView.addSubview(shadowView)
        keyboardView.addSubview(notifyView)
        
        keyboardView.clipsToBounds = false
        keyboardView.backgroundColor = UIColor.init(r: 255, g: 255, b: 255, a: 40)
        
        keyboardAreaView.addSubview(stackView1)
        keyboardAreaView.addSubview(stackView2)
        keyboardAreaView.addSubview(stackView3)
        keyboardAreaView.addSubview(stackView4)
        if !isLand && ENSettingManager.shared.keyboardType == .tenkey {
            keyboardAreaView.addSubview(stackView5)
        }
        
        return keyboardView
    }
    
    public func removeAllKeyboardView() {
        for innerView in keyboardView.subviews {
            innerView.removeFromSuperview()
        }
    }
    
    public func updateKeys() {
        keyboardManager?.loadKeys()
        keyboardManager?.keyboardTheme = keyboardTheme
    }
    
    public func initCustomArea(with custom:UIView) {
        customView.subviews.forEach { subView in
            subView.removeFromSuperview()
        }
        
        customView.addSubview(custom)
    }
    
    public func initNotifyArea(with notify: UIView) {
        notifyView.subviews.forEach { subView in
            subView.removeFromSuperview()
        }
        
        notifyView.addSubview(notify)
    }

    public func updateKeyboardHeight(isLand:Bool, addedContentHeight:CGFloat = 0.0 ) {
        self.isLand = isLand
        
        let subContentOffset = (isLand ? 0.0 : addedContentHeight)
        let keyboardHeight = ENSettingManager.shared.getKeyboardHeight(isLandcape: isLand) + subContentOffset
        var areaViewHeight = 0.0
        
        
            areaViewHeight = keyboardHeight-(ENSettingManager.shared.getKeyboardCustomHeight(isLandcape: isLand) + subContentOffset)
        
        
        self.heightConstraint?.constant = keyboardHeight
        self.keyboardHeightConstraint?.constant = areaViewHeight
        
        updateNotifyViewConstraint()
    }
}

// MARK: - ENEmojiViewDelegate & For EmojiView
extension ENKeyboardViewManager: ENEmojiViewDelegate {
    
    public func showEmojiView() {
        if let _ = emojiView?.superview {
            return
        }
        
        clearkeyboardAreaView()
        
        loadEmojiView()
        updateEmojiConstraints()
        emojiView?.setUpWith(emoji: .smileys)
    }
    
    public func dismissEmojiView() {
        guard let emojiView = emojiView else {
            return
        }
        
        self.closeEmojiView(emojiVeiw: emojiView)
    }
    
    
    public func loadEmojiView() {
        keyboardManager?.unloadKeyboard()

        emojiView = ENEmojiView.init(frame: .zero)
        emojiView?.proxy = proxy
        emojiView?.customTextField = customTextField
        
        emojiView?.delegate = self

        var buttonTitle = "ABC"
        if keyboardManager?.keyboardState != .letter {
            buttonTitle = "123"
        }
        else if keyboardManager?.keyboardState == .letter && !(keyboardManager?.isAlphabet ?? false) {
            buttonTitle = "한글"
        }
        emojiView?.returnKeyboardButton.setTitle(buttonTitle, for: .normal)

        if let emojiView = emojiView {
            self.keyboardAreaView.addSubview(emojiView)
        }
    }
    
    public func updateEmojiConstraints() {
        guard let emojiView = emojiView else {
            return
        }
        
        emojiView.translatesAutoresizingMaskIntoConstraints = false
        
        var layoutConstraints:[NSLayoutConstraint] = []
        let views: [String: Any] = [
            "emojiView": emojiView
        ]
        
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[emojiView]|", metrics: nil, views: views)
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[emojiView]|", metrics: nil, views: views)
        
        NSLayoutConstraint.activate(layoutConstraints)
    }
    
    
    public func closeEmojiView(emojiVeiw: ENEmojiView) {
        self.emojiView?.removeFromSuperview()
        self.emojiView = nil
        
        self.updateKeys()
        self.delegate?.enKeyboardViewManager(self, restoreToKeyboard: true)
    }
    
}

// MARK: - For Custom Contents
public extension ENKeyboardViewManager {
    
    func clearkeyboardAreaView() {
        for sub in self.keyboardAreaView.subviews {
            if sub != stackView1 && sub != stackView2 && sub != stackView3 && sub != stackView4 && sub != stackView5 {
                sub.removeFromSuperview()
            }
        }
    }
 
    func showCustomContents(customView: UIView?) {
        guard let customView = customView, customView.superview == nil else {
            return
        }
        
        keyboardManager?.unloadKeyboard()
        clearkeyboardAreaView()
        
        self.keyboardAreaView.addSubview(customView)
        
        customView.translatesAutoresizingMaskIntoConstraints = false
        
        var layoutConstraints:[NSLayoutConstraint] = []
        let views: [String: Any] = [
            "customView": customView
        ]
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[customView]|", metrics: nil, views: views)
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[customView]|", metrics: nil, views: views)
        
        customContentLayoutConstraint = layoutConstraints
        
        NSLayoutConstraint.activate(layoutConstraints)
        
    }
    
    func updateContentView() {
        for sub in self.keyboardAreaView.subviews {
            if sub != stackView1 && sub != stackView2 && sub != stackView3 && sub != stackView4 && sub != stackView5 {
                sub.removeConstraints(customContentLayoutConstraint)
                var layoutConstraints: [NSLayoutConstraint] = []
                let views: [String: Any] = [
                    "contentView": sub
                ]
                
                layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[contentView]|", metrics: nil, views: views)
                layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[contentView]|", metrics: nil, views: views)
                
                customContentLayoutConstraint = layoutConstraints
                
                NSLayoutConstraint.activate(layoutConstraints)
            }
        }
    }
    
    func restoreKeyboardViewFrom(customView: UIView?) {
        customContentView.removeFromSuperview()
        for sub in customContentView.subviews {
            sub.removeFromSuperview()
        }
        
        clearkeyboardAreaView()
        
        self.updateKeys()
        self.delegate?.enKeyboardViewManager(self, restoreToKeyboard: true)
    }
}



// MARK: - View Constraint Update
extension ENKeyboardViewManager {
    
    public func removeConstraints() {
        stackView1.removeConstraints(stackView1.constraints)
        stackView2.removeConstraints(stackView2.constraints)
        stackView3.removeConstraints(stackView3.constraints)
        stackView4.removeConstraints(stackView4.constraints)
        stackView5.removeConstraints(stackView5.constraints)
        
        keyboardView.removeConstraints(keyboardView.constraints)
        customView.removeConstraints(customView.constraints)
        keyboardAreaView.removeConstraints(keyboardAreaView.constraints)
        backgroundImageView.removeConstraints(backgroundImageView.constraints)
        shadowView.removeConstraints(shadowView.constraints)
        
        notifyView.removeConstraints(notifyView.constraints)
        
        customContentView.removeFromSuperview()
    }
    
    public func updateConstraints() {
        removeConstraints()
        
        keyboardView.translatesAutoresizingMaskIntoConstraints = false
        customView.translatesAutoresizingMaskIntoConstraints = false
        keyboardAreaView.translatesAutoresizingMaskIntoConstraints = false
        stackView1.translatesAutoresizingMaskIntoConstraints = false
        stackView2.translatesAutoresizingMaskIntoConstraints = false
        stackView3.translatesAutoresizingMaskIntoConstraints = false
        stackView4.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        shadowView.translatesAutoresizingMaskIntoConstraints = false
        
        notifyView.translatesAutoresizingMaskIntoConstraints = false
        
        if ENSettingManager.shared.keyboardType == .tenkey  {
            stackView5.translatesAutoresizingMaskIntoConstraints = false
        }
        
        var views: [String: Any] = [
            "keyboardView": keyboardView,
            "backgroundImageView": backgroundImageView,
            "customView": customView,
            "keyboardAreaView": keyboardAreaView,
            "stackView1": stackView1,
            "stackView2": stackView2,
            "stackView3": stackView3,
            "stackView4": stackView4,
            "shadowView": shadowView,
            "notifyView": notifyView
            
        ]
        
        if ENSettingManager.shared.keyboardType == .tenkey  {
            stackView5.translatesAutoresizingMaskIntoConstraints = false
            views["stackView5"] = stackView5
        }
        
        
        if isLand {
            updateConstraintsForQwerty(views)
        }
        else {
            switch UserDefaults.enKeyboardGroupStandard?.getKeyboardType() {
            case .tenkey:
                updateConstraintsFor10Key(views)
            default:
                updateConstraintsForQwerty(views)
            }
        }
        
        if let _ = customContentSubView {
            self.showCustomContents(customView: customContentView)
        }
    }
    
    
    
    public func updateNotifyViewConstraint() {
        var layoutConstraints:[NSLayoutConstraint] = []
        
        var keyboardHeight = ENSettingManager.shared.getKeyboardHeight(isLandcape: self.isLand)
        var areaViewHeight:CGFloat = 0.0
        
        if self.isLand {
            notifyHeightConstraint?.isActive = false
            notifyHeightConstraint = NSLayoutConstraint(item: notifyView,
                                                        attribute: NSLayoutConstraint.Attribute.height,
                                                        relatedBy: NSLayoutConstraint.Relation.equal,
                                                        toItem: nil,
                                                        attribute: NSLayoutConstraint.Attribute.notAnAttribute,
                                                        multiplier: 1.0,
                                                        constant: 0)
            layoutConstraints.append(notifyHeightConstraint!)
            
                areaViewHeight = keyboardHeight - (ENSettingManager.shared.getKeyboardCustomHeight(isLandcape: isLand))
            
            
            heightConstraint?.isActive = false
            heightConstraint = NSLayoutConstraint(item: keyboardView,
                                                  attribute: NSLayoutConstraint.Attribute.height,
                                                  relatedBy: NSLayoutConstraint.Relation.equal,
                                                  toItem: nil,
                                                  attribute: NSLayoutConstraint.Attribute.notAnAttribute,
                                                  multiplier: 1.0,
                                                  constant: keyboardHeight)
            layoutConstraints.append(heightConstraint!)
            
            keyboardHeightConstraint?.isActive = false
            keyboardHeightConstraint = NSLayoutConstraint(item: keyboardAreaView,
                                                     attribute: NSLayoutConstraint.Attribute.height,
                                                     relatedBy: NSLayoutConstraint.Relation.equal,
                                                     toItem: nil,
                                                     attribute: NSLayoutConstraint.Attribute.notAnAttribute,
                                                     multiplier: 1.0,
                                                     constant: areaViewHeight)
            layoutConstraints.append(keyboardHeightConstraint!)
        } else {
            if isUseNotifyView {
                notifyHeightConstraint?.isActive = false
                notifyHeightConstraint = NSLayoutConstraint(item: notifyView,
                                                            attribute: NSLayoutConstraint.Attribute.height,
                                                            relatedBy: NSLayoutConstraint.Relation.equal,
                                                            toItem: nil,
                                                            attribute: NSLayoutConstraint.Attribute.notAnAttribute,
                                                            multiplier: 1.0,
                                                            constant: 50)
                layoutConstraints.append(notifyHeightConstraint!)
                
                
                    keyboardHeight = keyboardHeight + 50
                    areaViewHeight = keyboardHeight - (ENSettingManager.shared.getKeyboardCustomHeight(isLandcape: isLand)) - 50
                
                
                heightConstraint?.isActive = false
                heightConstraint = NSLayoutConstraint(item: keyboardView,
                                                      attribute: NSLayoutConstraint.Attribute.height,
                                                      relatedBy: NSLayoutConstraint.Relation.equal,
                                                      toItem: nil,
                                                      attribute: NSLayoutConstraint.Attribute.notAnAttribute,
                                                      multiplier: 1.0,
                                                      constant: keyboardHeight)
                layoutConstraints.append(heightConstraint!)
                
                keyboardHeightConstraint?.isActive = false
                keyboardHeightConstraint = NSLayoutConstraint(item: keyboardAreaView,
                                                         attribute: NSLayoutConstraint.Attribute.height,
                                                         relatedBy: NSLayoutConstraint.Relation.equal,
                                                         toItem: nil,
                                                         attribute: NSLayoutConstraint.Attribute.notAnAttribute,
                                                         multiplier: 1.0,
                                                         constant: areaViewHeight)
                layoutConstraints.append(keyboardHeightConstraint!)
            } else {
                notifyHeightConstraint?.isActive = false
                notifyHeightConstraint = NSLayoutConstraint(item: notifyView,
                                                            attribute: NSLayoutConstraint.Attribute.height,
                                                            relatedBy: NSLayoutConstraint.Relation.equal,
                                                            toItem: nil,
                                                            attribute: NSLayoutConstraint.Attribute.notAnAttribute,
                                                            multiplier: 1.0,
                                                            constant: 0)
                layoutConstraints.append(notifyHeightConstraint!)
                
                
                    areaViewHeight = keyboardHeight - (ENSettingManager.shared.getKeyboardCustomHeight(isLandcape: isLand))
                
                
                heightConstraint?.isActive = false
                heightConstraint = NSLayoutConstraint(item: keyboardView,
                                                      attribute: NSLayoutConstraint.Attribute.height,
                                                      relatedBy: NSLayoutConstraint.Relation.equal,
                                                      toItem: nil,
                                                      attribute: NSLayoutConstraint.Attribute.notAnAttribute,
                                                      multiplier: 1.0,
                                                      constant: keyboardHeight)
                layoutConstraints.append(heightConstraint!)
                
                keyboardHeightConstraint?.isActive = false
                keyboardHeightConstraint = NSLayoutConstraint(item: keyboardAreaView,
                                                         attribute: NSLayoutConstraint.Attribute.height,
                                                         relatedBy: NSLayoutConstraint.Relation.equal,
                                                         toItem: nil,
                                                         attribute: NSLayoutConstraint.Attribute.notAnAttribute,
                                                         multiplier: 1.0,
                                                         constant: areaViewHeight)
                layoutConstraints.append(keyboardHeightConstraint!)
            }
        }
        

        NSLayoutConstraint.activate(layoutConstraints)
    }
    
    func updateConstraintsForQwerty(_ views: [String: Any]) {
        var keyboardHeight = ENSettingManager.shared.getKeyboardHeight(isLandcape: false)
        var areaViewHeight:CGFloat = 0.0
        
        var layoutConstraints:[NSLayoutConstraint] = []
        
        if let superView = keyboardView.superview {
            layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[keyboardView]|", metrics: nil, views: views)
            layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[keyboardView]|", metrics: nil, views: views)
        }

        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[backgroundImageView]|", metrics: nil, views: views)
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[backgroundImageView]|", metrics: nil, views: views)

        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[shadowView]|", metrics: nil, views: views)

        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[customView]|", metrics: nil, views: views)
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[keyboardAreaView]|", metrics: nil, views: views)
        // 키간격 좌우 조절

        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-1-[stackView1]-1-|", metrics: nil, views: views)
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-1-[stackView2]-1-|", metrics: nil, views: views)
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-1-[stackView3]-1-|", metrics: nil, views: views)
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-1-[stackView4]-1-|", metrics: nil, views: views)
        
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[notifyView]|", metrics: nil, views: views)
        
        let customHeight = ENSettingManager.shared.getKeyboardCustomHeight(isLandcape: isLand)
            areaViewHeight = keyboardHeight - (customHeight)
            layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[notifyView]-0-[customView(\(customHeight))]-0-[keyboardAreaView]|", metrics: nil, views: views)
        
        //키간격 위아래조절
        let marginHeigt = isLand ? 6 : 10
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[stackView1]-\(marginHeigt)-[stackView2(==stackView1)]-\(marginHeigt)-[stackView3(==stackView1)]-\(marginHeigt)-[stackView4(==stackView1)]-2-|", metrics: nil, views: views)
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[shadowView(1)]", metrics: nil, views: views)

        // 이걸 해야 자꾸 늘어나는 영역을 막아줌
        heightConstraint?.isActive = false
        heightConstraint = NSLayoutConstraint(item: keyboardView,
                                              attribute: NSLayoutConstraint.Attribute.height,
                                              relatedBy: NSLayoutConstraint.Relation.equal,
                                              toItem: nil,
                                              attribute: NSLayoutConstraint.Attribute.notAnAttribute,
                                              multiplier: 1.0,
                                              constant: keyboardHeight)
        layoutConstraints.append(heightConstraint!)

        keyboardHeightConstraint?.isActive = false
        keyboardHeightConstraint = NSLayoutConstraint(item: keyboardAreaView,
                                                 attribute: NSLayoutConstraint.Attribute.height,
                                                 relatedBy: NSLayoutConstraint.Relation.equal,
                                                 toItem: nil,
                                                 attribute: NSLayoutConstraint.Attribute.notAnAttribute,
                                                 multiplier: 1.0,
                                                 constant: areaViewHeight)
        layoutConstraints.append(keyboardHeightConstraint!)

        NSLayoutConstraint.activate(layoutConstraints)
        
        updateNotifyViewConstraint()
        
    }
    
    func updateConstraintsFor10Key(_ views: [String: Any]) {
        var keyboardHeight = ENSettingManager.shared.getKeyboardHeight(isLandcape: false)
        var areaViewHeight:CGFloat = 0.0
        
        var layoutConstraints:[NSLayoutConstraint] = []
        
        if let superView = keyboardView.superview {
            layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[keyboardView]|", metrics: nil, views: views)
            layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[keyboardView]|", metrics: nil, views: views)
        }
        
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[backgroundImageView]|", metrics: nil, views: views)
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[backgroundImageView]|", metrics: nil, views: views)
        
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[shadowView]|", metrics: nil, views: views)
        
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[customView]|", metrics: nil, views: views)
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[keyboardAreaView]|", metrics: nil, views: views)
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-3-[stackView1]-2-[stackView2(==stackView1)]-2-[stackView3(==stackView1)]-2-[stackView4(==stackView1)]-2-[stackView5(==stackView1)]-3-|", metrics: nil, views: views)
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[stackView1]-3-|", metrics: nil, views: views)
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[stackView2]-3-|", metrics: nil, views: views)
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[stackView3]-3-|", metrics: nil, views: views)
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[stackView4]-3-|", metrics: nil, views: views)
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[stackView5]-3-|", metrics: nil, views: views)
        
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[notifyView]|", metrics: nil, views: views)
        
       
            areaViewHeight = keyboardHeight - (ENSettingManager.shared.getKeyboardCustomHeight(isLandcape: isLand))
    
            layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[notifyView]-0-[customView(50)]-0-[keyboardAreaView]|", metrics: nil, views: views)
        

        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[shadowView(1)]", metrics: nil, views: views)
        
        heightConstraint?.isActive = false
        heightConstraint = NSLayoutConstraint(item: keyboardView,
                                              attribute: NSLayoutConstraint.Attribute.height,
                                              relatedBy: NSLayoutConstraint.Relation.equal,
                                              toItem: nil,
                                              attribute: NSLayoutConstraint.Attribute.notAnAttribute,
                                              multiplier: 1.0,
                                              constant: keyboardHeight)
        layoutConstraints.append(heightConstraint!)
        
        keyboardHeightConstraint?.isActive = false
        keyboardHeightConstraint = NSLayoutConstraint(item: keyboardAreaView,
                                                 attribute: NSLayoutConstraint.Attribute.height,
                                                 relatedBy: NSLayoutConstraint.Relation.equal,
                                                 toItem: nil,
                                                 attribute: NSLayoutConstraint.Attribute.notAnAttribute,
                                                 multiplier: 1.0,
                                                 constant: areaViewHeight)
        layoutConstraints.append(keyboardHeightConstraint!)
        
        NSLayoutConstraint.activate(layoutConstraints)
        
        updateNotifyViewConstraint()
    }
}
