//
//  EN10KeyManager.swift
//  KeyboardSDKCore
//
//  Created by enlipleIOS1 on 2021/09/07.
//

import Foundation
import UIKit

public class EN10KeyManager: ENKeyboardManager {
    
    var nextInputButton:EN10KeyButtonView? = nil
    var nextInputTimer:Timer? = nil
    let frameHeightSupportedNum = 110.0
    
    public override init(with proxy: UITextDocumentProxy?, needsInputModeSwitchKey:Bool) {
        super.init(with: proxy, needsInputModeSwitchKey: needsInputModeSwitchKey)
        automata = EN10KeyAutomata.init(with: proxy)
    }
    
    
    public override func updateKeyboardFrame(frame: CGRect) {
        if frame.width == keyboardFrame.width && frame.height == keyboardFrame.height {
            return
        }
        super.updateKeyboardFrame(frame: frame)
        
//        let frameHeight = frame.size.height - 70.0
        let frameHeight = ENSettingManager.shared.getKeyboardHeight(isLandcape: false) - frameHeightSupportedNum  + 50
        let buttonHeight:CGFloat = ((frameHeight < 6 ? ENSettingManager.shared.getKeyboardHeight(isLandcape: false) : frameHeight) - 6) / CGFloat(ENConstants.alphabet10Key[0].count)
        DHLogger.log("10101010 [button size] buttonHeight : \(buttonHeight)  from \(frame) and updateKeyboardFrame")
        
        keys.forEach {
            
            guard let button = $0 as? EN10KeyButtonView else { return }
            
            let key = button.original

            if key == "⮐" {
                $0.removeConstraints($0.constraints)
                $0.heightAnchor.constraint(equalToConstant: buttonHeight * 2.0).isActive = true
                button.addDefaultConstraint()
            }
            else if (key == "🌐" || key == "☺︎") {
                $0.superview?.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
            }
            else {
                $0.removeConstraints($0.constraints)
                $0.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
                button.addDefaultConstraint()
            }
        }
        
        paddingViews.forEach {
            $0.removeConstraints($0.constraints)
            $0.heightAnchor.constraint(equalToConstant: buttonHeight/2.0).isActive = true
        }
        
    }
    
    public override func themeChanged() {
        keys.forEach {
            ($0 as? EN10KeyButtonView)?.keyboardTheme = keyboardTheme
        }
        paddingViews.forEach {
            ($0 as? EN10KeyButtonView)?.keyboardTheme = keyboardTheme
        }
    }
    
    public override func unloadKeyboard() {
        keys.forEach{
            ($0 as? EN10KeyButtonView)?.backgroundImageView.image = nil
            ($0 as? EN10KeyButtonView)?.backgroundImageView.highlightedImage = nil
            ($0 as? EN10KeyButtonView)?.iconImageView.image = nil
            
            let key = ($0 as? EN10KeyButtonView)?.original
            if needsInputModeSwitchKey && (key == "🌐" || key == "☺︎") {
                $0.superview?.removeFromSuperview()
                $0.removeFromSuperview()
            }
            else {
                $0.removeFromSuperview()
            }
        }
        
        paddingViews.forEach{
            ($0 as? EN10KeyButtonView)?.backgroundImageView.image = nil
            ($0 as? EN10KeyButtonView)?.backgroundImageView.highlightedImage = nil
            ($0 as? EN10KeyButtonView)?.iconImageView.image = nil
            $0.removeFromSuperview()
        }
    }
    
    public override func loadKeys(_ size: CGSize = .zero) {
        self.unloadKeyboard()
        
        let frameHeight = ENSettingManager.shared.getKeyboardHeight(isLandcape: false) - frameHeightSupportedNum  + 50
        
        let buttonHeight:CGFloat = ((frameHeight < 6 ? ENSettingManager.shared.getKeyboardHeight(isLandcape: false) : frameHeight) - 6) / CGFloat(ENConstants.alphabet10Key[0].count)
//        DHLogger.log("[button size] buttonHeight : \(buttonHeight)  from \(size) and loadKeys")
        
        var keyboard: [[String]]
        var subKeyboard: [[String]]? = nil

        //select keyboard, start padding
        switch keyboardState {
        case .numbers, .symbols:
            keyboard = ENConstants.number10Key
            subKeyboard = ENConstants.numberSub10Key

        default:            //case .letter
            if isAlphabet {
                keyboard = ENConstants.alphabet10Key
                subKeyboard = nil
            }
            else {
                keyboard = ENConstants.hangle10Key
                subKeyboard = nil
            }
        }
        (automata as? EN10KeyAutomata)?.keyboard = keyboard
        
        let numRows = keyboard.count
        for row in 0...numRows - 1 {
            for col in 0...keyboard[row].count - 1 {
                let key = keyboard[row][col]
                let subKey = subKeyboard?[row][col]
                
                let button = EN10KeyButtonView(key: key, subKey: subKey ?? "", shiftButtonState: shiftButtonState, keyboardState: keyboardState, theme: keyboardTheme)
                button.delegate = self
                button.row = row
                button.needsInputModeSwitchKey = needsInputModeSwitchKey
                button.isAlphabet = isAlphabet
                
                if keyboardTheme.isPhotoTheme {
                    button.backgroundImageView.layer.applyRounding(cornerRadius: 5, borderColor: .clear, borderWidth: 0.0, masksToBounds: true)
                }
                else {
                    button.backgroundImageView.layer.applyRounding(cornerRadius: 0, borderColor: .clear, borderWidth: 0.0, masksToBounds: false)
                }

                if key == "⌫" {
                    let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(keyLongPressed(_:)))
                    button.addGestureRecognizer(longPressRecognizer)
                }
                
                keys.append(button)

                switch row {
                case 0: stackView1?.addArrangedSubview(button)
                case 1: stackView2?.addArrangedSubview(button)
                case 2: stackView3?.addArrangedSubview(button)
                case 3: stackView4?.addArrangedSubview(button)
                case 4: stackView5?.addArrangedSubview(button)
                default:
                    break
                }

                button.isSpecial = (row == 0 || row == 4)
                if key == "⮐" {
                    button.heightAnchor.constraint(equalToConstant: buttonHeight * 2.0).isActive = true
                }
                else {
                    button.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
                }
                
                if key == "→" {
                    nextInputButton = button
                }
                
                
                if key == "☺︎" {
                    if needsInputModeSwitchKey {
                        button.removeFromSuperview()
                        
                        let subView = UIView(frame: .zero)
                        stackView1?.addArrangedSubview(subView)
                        
                        let globalButton = EN10KeyButtonView(key: "🌐", subKey: subKey ?? "", shiftButtonState: shiftButtonState, keyboardState: keyboardState, theme: keyboardTheme)
                        globalButton.delegate = self
                        globalButton.row = row
                        globalButton.needsInputModeSwitchKey = needsInputModeSwitchKey
                        globalButton.isAlphabet = isAlphabet
                        globalButton.isSpecial = true
                        keys.append(globalButton)
                        
                        nextKeyboardButton = globalButton
                        nextKeyboardButton?.isUserInteractionEnabled = true
                        
                        globalButton.iconImageView.image = keyboardTheme.keyGlobalImage
                        globalButton.titleLabel.text = "한영"
                        globalButton.titleLabel.isHidden = true
                        
                        initGlobalKey()
                        
                        if keyboardTheme.isPhotoTheme {
                            globalButton.backgroundImageView.backgroundColor = keyboardTheme.themeColors.sp_btn_color
                            globalButton.backgroundImageView.image = nil
                        }
                        else {
                            globalButton.backgroundImageView.image = keyboardTheme.specialKeyNormalBackgroundImage
                            globalButton.backgroundImageView.highlightedImage = keyboardTheme.specialKeyPressedBackgroundImage
                            globalButton.titleLabel.textColor = keyboardTheme.themeColors.specialKeyTextColor
                            globalButton.titleLabel.highlightedTextColor = keyboardTheme.themeColors.specialKeyTextColor
                        }
                        
                        subView.addSubview(button)
                        subView.addSubview(globalButton)
                        
                        var layoutConstraints:[NSLayoutConstraint] = []
                        let views: [String: Any] = [
                            "globalButton": globalButton,
                            "button": button
                        ]
                        
                        globalButton.translatesAutoresizingMaskIntoConstraints = false
                        button.translatesAutoresizingMaskIntoConstraints = false

                        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[button]-2-[globalButton(==button)]-0-|", metrics: nil, views: views)
                        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[button]-0-|", metrics: nil, views: views)
                        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[globalButton]-0-|", metrics: nil, views: views)
                        
                        NSLayoutConstraint.activate(layoutConstraints)
                        
                        subView.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
                        
                    }
                    else {
                        button.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true

                        if keyboardTheme.isPhotoTheme {
                            button.iconImageView.image = nil
                            button.titleLabel.text = "☺︎"
                        }
                        else {
                            button.iconImageView.image = keyboardTheme.keyEmojiIcon
                            button.titleLabel.text = ""
                        }
                    }
                    
                }
                else if key == "⇧" {
                    button.iconImageView.image = keyboardTheme.keyShiftNormalImage
                    button.titleLabel.text = ""
                    
                    if shiftButtonState != .normal {
                        button.iconImageView.image = keyboardTheme.keyShiftPressedImage
                    }
                    
                    if shiftButtonState == .caps {
                        button.iconImageView.image = keyboardTheme.keyCapslockImage
                    }
                    
                }
                else if key == "⌫" {
                    button.original = key
                    button.titleLabel.text = ""
                    button.iconImageView.image = keyboardTheme.keyDeleteImage
                }
                else if key == "⮐" {
                    button.original = key
                    button.titleLabel.text = ""
                    button.iconImageView.image = keyboardTheme.keyEnterImage
                }
                else if key == "space" {
                    button.original = key
                    button.titleLabel.text = ""
                    button.iconImageView.image = keyboardTheme.keySpaceImage
                    
                    button.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(spaceKeyLongPressed(sender:))))
                }
                else {
                }
                
                if  button.isSpecial {
                    if keyboardTheme.isPhotoTheme {
                        button.backgroundImageView.backgroundColor = keyboardTheme.themeColors.sp_btn_color
                        button.backgroundImageView.image = nil
                    }
                    else {
                        button.backgroundImageView.image = keyboardTheme.specialKeyNormalBackgroundImage
                        button.backgroundImageView.highlightedImage = keyboardTheme.specialKeyPressedBackgroundImage
                        button.titleLabel.textColor = keyboardTheme.themeColors.specialKeyTextColor
                        button.titleLabel.highlightedTextColor = keyboardTheme.themeColors.specialKeyTextColor
                    }
                }
                else {
                    if keyboardTheme.isPhotoTheme {
                        button.backgroundImageView.backgroundColor = keyboardTheme.themeColors.nor_btn_color
                        button.backgroundImageView.image = nil
                    }
                    else {
                        button.backgroundImageView.image = keyboardTheme.keyNormalBackgroundImage
                        button.backgroundImageView.highlightedImage = keyboardTheme.keyPressedBackgroundImage
                        button.titleLabel.textColor = keyboardTheme.themeColors.key_text
                        button.titleLabel.highlightedTextColor = keyboardTheme.themeColors.key_text
                    }
                }
                
                button.updateKeyboardTypeButtons()
            }
        }
    }
    // MARK: 매번 loadKeys하면 메모리 누수 생기고 뷰를 새로만들어서 cancelled로 들어옴 / 추가 된 날짜 : 2024 01 24 / 손재민
    func changeKeys(){
            
            var keyboard: [[String]]
        var subKeyboard: [[String]]? = nil

        switch keyboardState {
        case .numbers, .symbols:
            keyboard = ENConstants.number10Key
            subKeyboard = ENConstants.numberSub10Key

        default:            //case .letter
            if isAlphabet {
                keyboard = ENConstants.alphabet10Key
                subKeyboard = nil
            }
            else {
                keyboard = ENConstants.hangle10Key
                subKeyboard = nil
            }
        }
        (automata as? EN10KeyAutomata)?.keyboard = keyboard
        
            let numRows = keyboard.count
        for row in 0...numRows - 1{
                for col in 0...keyboard[row].count - 1{
                    let key = keyboard[row][col]
                    let subKey = subKeyboard?[row][col]
                    var button: EN10KeyButtonView! = nil
                    if row == 0 {
                         button  =  stackView1?.arrangedSubviews[col] as? EN10KeyButtonView
                    }else if row == 1{
                        button  =  stackView2?.arrangedSubviews[col] as? EN10KeyButtonView
                    }else if row == 2{
                        button  =  stackView3?.arrangedSubviews[col] as? EN10KeyButtonView
                    }else if row == 3{
                        button  =  stackView4?.arrangedSubviews[col] as? EN10KeyButtonView
                    }

                    if key == "⌫" {
    //                    button.iconImageView.image = keyboardTheme.keyDeleteImage
                    }else{
                        button?.update(key: key,subKey: subKey ?? "", shiftButtonState: shiftButtonState)
                        button?.original = key
                        button?.keyToDisplay = key
                        button?.subKeys = subKey ?? ""
                    }
                }
                
            }
    }
    
    
    func changeKeyboardToNumberKeys() {
        keyboardState = .numbers
        shiftButtonState = .normal
        loadKeys()
    }
    func changeKeyboardToAlphabetKeys() {
        keyboardState = .letter
        isAlphabet = true
        loadKeys()
    }
    func changeKeyboardToHangleKeys() {
        keyboardState = .letter
        isAlphabet = false
        loadKeys()
        
    }
    
    override func handlDeleteButtonPressed() {
        if let automata = automata as? ENKoreanAutomata {
            if keyboardState == .letter && !isAlphabet && automata.realInputedChars.count > 0 {
                automata.realInputedChars.remove(at: automata.realInputedChars.count-1)
                automata.makeTextWith(inputed: nil)
            }
            else {
                automata.deleteBackword()
            }

            delegate?.textInputted(manager: self, text: nil)
        }
    }
}

    



    
//MARK:- 글로벌 키 설정
extension EN10KeyManager {
    func initGlobalKey() {
        nextKeyboardButton?.gestureRecognizers?.forEach({ gesture in
            nextKeyboardButton?.removeGestureRecognizer(gesture)
        })

        nextKeyboardButton?.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(globalKeyTapped)))

        if needsInputModeSwitchKey {
            let longPress:UILongPressGestureRecognizer = UILongPressGestureRecognizer.init(target: self, action: #selector(globalKeyLongPressed(sender:)))
            longPress.numberOfTouchesRequired = 1
            nextKeyboardButton?.addGestureRecognizer(longPress)
        }
    }
    
    @objc func globalKeyTapped() {
        ENKeyButtonEffectManager.shared.excute()

        self.isAlphabet.toggle()
        if self.isAlphabet {
            changeKeyboardToAlphabetKeys()
        }
        else {
            changeKeyboardToHangleKeys()
        }
    }
    
    @objc func globalKeyLongPressed(sender: UILongPressGestureRecognizer) {
        
        if sender.state == .began {
            guard let next = nextKeyboardButton, let nextP = next.superview else {
                return
            }

            if globalSubMenu == nil {
                globalSubMenu = ENKeyboardGlobalSubMenuView.init(frame: .zero, theme: keyboardTheme.themeColors)
            }
            else {
                globalSubMenu?.changeTheme(theme: keyboardTheme.themeColors)
            }

            let subFrame = CGRect.init(origin: CGPoint(x: next.frame.origin.x,
                                                       y: nextP.frame.origin.y - (ENKeyboardGlobalSubMenuView.needSize.height + 5)),
                                       size: ENKeyboardGlobalSubMenuView.needSize)

            globalSubMenu?.delegate = self
            globalSubMenu?.setContentFrame(contentFrame: subFrame)
            globalSubMenu?.frame = stackView1?.superview?.bounds ?? .zero

            stackView1?.superview?.addSubview(globalSubMenu!)
            ENKeyButtonEffectManager.shared.excute()
        }
    }
    
}


extension EN10KeyManager:ENKeyboardGlobalSubMenuViewDelegate {
    
    public func globalSubMenuTapped(menu: ENKeyboardGlobalSubMenuView, action: ENKeyboardGlobalSubMenuViewAction) {
        menu.removeFromSuperview()

        switch action {
        case .toEnglish:
            self.changeKeyboardToAlphabetKeys()
            break

        case .toKorean:
            self.changeKeyboardToHangleKeys()
            break

        case .changeKeyboard:
            delegate?.handleInputModeList(manager: self)
            break
        }
    }
}





//MARK:- EN10KeyButtonViewDelegate Method
extension EN10KeyManager: EN10KeyButtonViewDelegate {
    
    /**
     키보드를 눌렀다가 땔 때
     기존코드에 키보드 백그라운드 이미지를 normal 로 바꾸는 부분만 추가함
     */
    func enKeyPressedTouchUp(_ sender: EN10KeyButtonView?) {
        guard let originalKey = sender?.original, let keyToDisplay = sender?.keyToDisplay else {return}

        switch originalKey {
        case "⌫":
            if shiftButtonState == .shift {
                shiftButtonState = .normal
//                loadKeys()
                changeKeys()
            }
            handlDeleteButtonPressed()

        case "space":
            automata?.insertText(" ")
            delegate?.textInputted(manager: self, text: " ")
            automata?.clearInputed()
            
        case "🌐":
            break

        case "☺︎":
            delegate?.showEmojiView(manager: self)
            break

        case "⮐":
            automata?.insertText("\n")
            delegate?.textInputted(manager: self, text: "\n")
            automata?.clearInputed()

        case "#123":
            changeKeyboardToNumberKeys()

        case "ABC":
            changeKeyboardToAlphabetKeys()
            
        case "한글":
            changeKeyboardToHangleKeys()
        
        case "⇧":
            shiftButtonState = shiftButtonState == .normal ? .shift : .normal
//            loadKeys()
            changeKeys()

        default:
            preview.hidePreview(from: sender)
            
            delegate?.textInputted(manager: self, text: keyToDisplay)
            automata?.makeTextWith(inputed: keyToDisplay)
            
            startNextInputTimeOut()
        }
        
        // MARK: 키보드를 땠을 때 이미지 복귀 / 추가 된 날짜 : 2023 08 14 / xim
        if !(sender?.isSpecial ?? false) {
            if keyboardTheme.keyNormalBackgroundImage != nil {
                sender?.backgroundImageView.image = keyboardTheme.keyNormalBackgroundImage
            }
        } else {
            if keyboardTheme.specialKeyNormalBackgroundImage != nil {
                sender?.backgroundImageView.image = keyboardTheme.specialKeyNormalBackgroundImage
            }
        }
        
        sender?.updateKeyboardTypeButtons()
    }
    
    
    func enKeyMultiPress(_ sender: EN10KeyButtonView?) {
        guard let originalKey = sender?.original else {return}

        if (originalKey == "⇧") {
            shiftButtonState = .caps
//            loadKeys()
            changeKeys()

        }
        
    }
    
    // MARK: 키를 눌렀을 때 이미지 교체 / 추가 된 날짜 : 2023 08 14 / xim
    func enKeyTouchDown(_ sender: EN10KeyButtonView?) {
        if !(sender?.isSpecial ?? false) {
            if keyboardTheme.keyPressedBackgroundImage != nil {
                sender?.backgroundImageView.image = keyboardTheme.keyPressedBackgroundImage
            }
        } else {
            if keyboardTheme.specialKeyPressedBackgroundImage != nil {
                sender?.backgroundImageView.image = keyboardTheme.specialKeyPressedBackgroundImage
            }
        }
    }
    
}


extension EN10KeyManager {
    
    
    func startNextInputTimeOut() {
        nextInputButton?.backgroundImageView.isHighlighted = true
        nextInputButton?.isUserInteractionEnabled = true
        
        nextInputTimer?.invalidate()
        
        nextInputTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false, block: { [weak self] t in
            guard let self else { return }
            self.nextInputTimer?.invalidate()
            self.nextInputTimer = nil
            
            self.nextInputButton?.backgroundImageView.isHighlighted = false
            self.nextInputButton?.isUserInteractionEnabled = false
            
            self.automata?.clearInputed()
        })
        
        
    }
}
