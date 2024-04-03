//
//  ENQwertyManager.swift
//  KeyboardSDKCore
//
//  Created by enlipleIOS1 on 2021/05/04.
//

import Foundation
import UIKit

public class ENQwertyManager: ENKeyboardManager {
    
    public override init(with proxy: UITextDocumentProxy?, needsInputModeSwitchKey:Bool) {
        super.init(with: proxy, needsInputModeSwitchKey: needsInputModeSwitchKey)
        automata = ENKoreanQwertyAutomata.init(with: proxy)
    }
    
    
    public override func updateKeyboardFrame(frame: CGRect) {
        if frame.width == keyboardFrame.width && frame.height == keyboardFrame.height {
            return
        }
        
        super.updateKeyboardFrame(frame: frame)
        
        var frameWidth = frame.size.width   // < frame.size.height ? frame.size.width : frame.size.height
        if (!needsInputModeSwitchKey) {
            if frame.size.width == max(UIScreen.main.bounds.width, UIScreen.main.bounds.height) {
                frameWidth *= 0.815
            }
        }
        
        let buttonWidth:CGFloat = ((frameWidth < 6 ? UIScreen.main.bounds.width : frameWidth) - 6) / CGFloat(ENConstants.alphabetKeys[0].count)
        DHLogger.log("[button size] buttonWidth : \(buttonWidth)  from \(frame) and updateKeyboardFrame")
        
        keys.forEach {
            $0.removeConstraints($0.constraints)
            
            guard let button = $0 as? ENKeyButtonView else { return }
            button.addDefaultConstraint()
            
            let key = button.original
            let row = button.row
            
            if (button.isSpecial && key != "space") {
                if key == "⮐" {
                    $0.widthAnchor.constraint(equalToConstant: buttonWidth * 1.8).isActive = true
                }
                else if key == "☺︎" {
                    $0.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
                }
                else if key == "⇧" || key == "⌫" {
                    $0.widthAnchor.constraint(equalToConstant: buttonWidth * 1.3).isActive = true
                }
                else {
                    $0.widthAnchor.constraint(equalToConstant: buttonWidth * 1.15).isActive = true
                }
            }
            else if (keyboardState == .numbers || keyboardState == .symbols) && row == 2 {
                $0.widthAnchor.constraint(equalToConstant: buttonWidth * 1.4).isActive = true
            }else if key == "space"{
                $0.widthAnchor.constraint(equalToConstant: buttonWidth * 5.0).isActive = true
            }
            else {
                $0.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
            }
        }
        paddingViews.forEach {
            $0.removeConstraints($0.constraints)
            $0.widthAnchor.constraint(equalToConstant: buttonWidth/2.0).isActive = true
        }
        
    }
    
    public override func themeChanged() {
        keys.forEach {
            ($0 as? ENKeyButtonView)?.keyboardTheme = keyboardTheme
        }
        paddingViews.forEach {
            ($0 as? ENKeyButtonView)?.keyboardTheme = keyboardTheme
        }
    }
    
    
    public override func loadKeys(_ size: CGSize = .zero) {
        self.unloadKeyboard()
        
        var frameWidth = size.width
        if frameWidth == 0 {
            frameWidth = keyboardFrame.size.width
        }
        if frameWidth == 0 {
            frameWidth = UIScreen.main.bounds.width
        }
        
        if (!needsInputModeSwitchKey) {
            if frameWidth == max(UIScreen.main.bounds.width, UIScreen.main.bounds.height) {
                frameWidth *= 0.815
            }
        }
        
        let buttonWidth:CGFloat = ((frameWidth < 6 ? UIScreen.main.bounds.width : frameWidth) - 6) / CGFloat(ENConstants.alphabetKeys[0].count)
//        DHLogger.log("[button size] buttonWidth : \(buttonWidth)  from \(size) and loadKeys")
        
        
        var keyboard: [[String]]
        
        //select keyboard, start padding
        switch keyboardState {
        case .numbers:
            keyboard = ENConstants.numberKeys
        
        case .symbols:
            keyboard = ENConstants.symbolKeys
        
        
        default:            //case .letter
            if isAlphabet {
                keyboard = ENConstants.alphabetKeys
                addPadding(to: stackView2, width: buttonWidth/2, key: "a")
            }
            else {
                keyboard = (shiftButtonState == .normal) ? ENConstants.hangleKeys : ENConstants.shiftedHangleKeys
                addPadding(to: stackView2, width: buttonWidth/2, key: "ㅁ")
            }
        }
        
        let numRows = keyboard.count
        for row in 0...numRows - 1{
            for col in 0...keyboard[row].count - 1{
                let key = keyboard[row][col]
                let button = ENKeyButtonView(key: key, shiftButtonState: shiftButtonState, theme: keyboardTheme)
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
                

                if key == "⌫"{
                    let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(keyLongPressed(_:)))
                    button.addGestureRecognizer(longPressRecognizer)
                }
                
                keys.append(button)
                switch row {
                case 0: stackView1?.addArrangedSubview(button)
                case 1: stackView2?.addArrangedSubview(button)
                case 2: stackView3?.addArrangedSubview(button)
                case 3: stackView4?.addArrangedSubview(button)
                default:
                    break
                }
                
                if key == "🌐"{
                    nextKeyboardButton = button
                    nextKeyboardButton?.isUserInteractionEnabled = true
                    initGlobalKey()
                }
                
                button.isSpecial = false
                
                stackView3?.setCustomSpacing(0, after: button)
                
                if key == "⌫" || key == "⮐" || key == "#+=" || key == "letter" || key == "123" || key == "⇧" || key == "🌐" || key == "☺︎" {
                    
                    if key == "⮐" {
                        button.widthAnchor.constraint(equalToConstant: buttonWidth * 1.8).isActive = true
                    }
                    else if key == "☺︎" {
                        button.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
                        
                        if keyboardTheme.isPhotoTheme {
                            button.iconImageView.image = nil
                            button.titleLabel.text = "☺︎"
                        }
                        else {
                            button.iconImageView.image = keyboardTheme.keyEmojiIcon
                            button.titleLabel.text = ""
                        }
                    }
                    else if key == "⇧" || key == "⌫" {
                        button.widthAnchor.constraint(equalToConstant: buttonWidth * 1.4).isActive = true
                    }
                    else {
                        button.widthAnchor.constraint(equalToConstant: buttonWidth * 1.15).isActive = true
                    }
                    
                    button.isSpecial = true
                    if keyboardTheme.isPhotoTheme {
                        button.backgroundImageView.backgroundColor = keyboardTheme.themeColors.sp_btn_color
                        button.backgroundImageView.image = nil
                    }
                    else {
                        button.backgroundImageView.image = keyboardTheme.specialKeyNormalBackgroundImage
                    }
                    
                    button.titleLabel.textColor = keyboardTheme.themeColors.specialKeyTextColor
                    
                    button.titleLabel.text = ""
                    
                    if key == "⇧" {
                        button.iconImageView.image = UIImage.init(named: "paikbd_btn_keyboard_shift", in: Bundle.frameworkBundle, compatibleWith: nil)
                        
                        if shiftButtonState != .normal {
                            button.iconImageView.image = UIImage.init(named: "paikbd_btn_keyboard_shift_2", in: Bundle.frameworkBundle, compatibleWith: nil)
                        }
                        
                        if shiftButtonState == .caps {
                            button.iconImageView.image = UIImage.init(named: "paikbd_btn_keyboard_shift_2", in: Bundle.frameworkBundle, compatibleWith: nil)
                        }
                        
                    }
                    
                    if key == "letter" {
                        button.titleLabel.text = (isAlphabet ? "ABC":"한글")
                    }
                    
                    if key == "123" {
                        button.titleLabel.text = key
                    }
                    
                    if key == "🌐" {
                        if needsInputModeSwitchKey {
                            button.iconImageView.image = keyboardTheme.keyGlobalImage
                        }
                        else {
                            button.iconImageView.image = keyboardTheme.keyGlobalImage
                            button.titleLabel.text = "한영"
                            button.titleLabel.isHidden = true
                            initGlobalKey()
                        }
                    }
                    
                    if key == "⌫" {
                        button.iconImageView.image = keyboardTheme.keyDeleteImage
                    }
                    if key == "⮐" {
                        button.iconImageView.image = keyboardTheme.keyEnterImage
                    }
                    if key == "#+=" {
                        button.iconImageView.image = keyboardTheme.keySpecialImage
                    }
                    
                    if key == "☺︎" {
                        if keyboardTheme.isPhotoTheme {
                            button.iconImageView.image = nil
                            button.titleLabel.text = key
                        }
                        else {
                            button.iconImageView.image = keyboardTheme.keyEmojiIcon
                            button.titleLabel.text = ""
                        }
                    }
                    
                }else if (keyboardState == .numbers || keyboardState == .symbols) && row == 2 {
                    button.widthAnchor.constraint(equalToConstant: buttonWidth * 1.4).isActive = true
                }else if key != "space"{
                    button.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
                }else{
                    button.isSpecial = true
                    
                    button.original = key
                    if keyboardTheme.isPhotoTheme {
                        button.backgroundImageView.backgroundColor = keyboardTheme.themeColors.sp_btn_color
                        button.backgroundImageView.image = nil
                    }
                    else {
                        button.backgroundImageView.image = keyboardTheme.specialKeyNormalBackgroundImage
                    }
                    button.titleLabel.text = ""
                    button.iconImageView.image = keyboardTheme.keySpaceImage
                    button.widthAnchor.constraint(equalToConstant: buttonWidth * 5.0).isActive = true
                    
                    button.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(spaceKeyLongPressed(sender:))))
                }
            }
        }
        
        //end padding
        if keyboardState == .letter {
            addPadding(to: stackView2, width: buttonWidth/2, key: (isAlphabet ? "l" : "ㅣ"))
        }
    }
    // MARK: 매번 loadKeys하면 메모리 누수 생기고 뷰를 새로만들어서 cancelled로 들어옴 / 추가 된 날짜 : 2024 01 24 / 손재민

    func changeKeys(){
        
        var keyboard: [[String]]
        
        //select keyboard, start padding
        switch keyboardState {
        case .numbers:
            keyboard = ENConstants.numberKeys
        
        case .symbols:
            keyboard = ENConstants.symbolKeys
        
        
        default:            //case .letter
            if isAlphabet {
                keyboard = ENConstants.alphabetKeys
            }
            else {
                keyboard = (shiftButtonState == .normal) ? ENConstants.hangleKeys : ENConstants.shiftedHangleKeys
            }
        }
        let numRows = keyboard.count
        for row in 0..<numRows - 1{

            for col in 0...keyboard[row].count - 1{
                let key = keyboard[row][col]

                var button: ENKeyButtonView! = nil
                if row == 0 {
                     button  =  stackView1?.arrangedSubviews[col] as? ENKeyButtonView
                }else if row == 1{
                    button  =  stackView2?.arrangedSubviews[col+1] as? ENKeyButtonView
                }else if row == 2{
                    button  =  stackView3?.arrangedSubviews[col] as? ENKeyButtonView
                }
                if key == "⇧" {
                    button.iconImageView.image = UIImage.init(named: "paikbd_btn_keyboard_shift", in: Bundle.frameworkBundle, compatibleWith: nil)
                    
                    if shiftButtonState != .normal {
                        button.iconImageView.image = UIImage.init(named: "paikbd_btn_keyboard_shift_2", in: Bundle.frameworkBundle, compatibleWith: nil)
                    }
                    
                    if shiftButtonState == .caps {
                        button.iconImageView.image = UIImage.init(named: "paikbd_btn_keyboard_shift_2", in: Bundle.frameworkBundle, compatibleWith: nil)
                    }
                    
                }else if key == "⌫" {
//                    button.iconImageView.image = keyboardTheme.keyDeleteImage
                }else{
                    button?.update(key: key, shiftButtonState: shiftButtonState)
                }

            }
        }
    }
    
    func addPadding(to stackView: UIStackView?, width: CGFloat, key: String){
        guard let stackView = stackView else {
            return
        }
        
        let padding = ENKeyButtonView.init(key: key, shiftButtonState: shiftButtonState, theme: keyboardTheme, isPadding: true)
        padding.frame = CGRect(x: 0, y: 0, width: 6, height: 7)
        padding.titleLabel.textColor = .clear
        padding.alpha = 1.0
        padding.widthAnchor.constraint(equalToConstant: width).isActive = true
        padding.delegate = self
        
        paddingViews.append(padding)
        stackView.addArrangedSubview(padding)
    }
    
    
    func changeKeyboardToNumberKeys() {
        keyboardState = .numbers
        shiftButtonState = .normal
        loadKeys()
    }
    func changeKeyboardToLetterKeys() {
        keyboardState = .letter
        loadKeys()
    }
    func changeKeyboardToSymbolKeys() {
        keyboardState = .symbols
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
extension ENQwertyManager {
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
        self.shiftButtonState = .normal
        changeKeyboardToLetterKeys()
    }
    
    @objc func globalKeyLongPressed(sender: UILongPressGestureRecognizer) {
        
        if sender.state == .began {
            guard let next = nextKeyboardButton, let nextP = self.stackView4 else {
                return
            }
            
            if globalSubMenu == nil {
                globalSubMenu = ENKeyboardGlobalSubMenuView.init(frame: .zero, theme: keyboardTheme.themeColors)
            }
            else {
                globalSubMenu?.changeTheme(theme: keyboardTheme.themeColors)
            }

//            let subFrame = CGRect.init(origin: CGPoint(x: next.frame.origin.x,
//                                                       y: nextP.frame.origin.y - (ENKeyboardGlobalSubMenuView.needSize.height + 5)),
//                                       size: ENKeyboardGlobalSubMenuView.needSize)
            let subFrame = CGRect.init(origin: CGPoint(x: next.frame.origin.x,
                                                       y: nextP.frame.origin.y - (ENKeyboardGlobalSubMenuView.needSize.height * 1.5)),
                                       size: ENKeyboardGlobalSubMenuView.needSize)
            
            globalSubMenu?.delegate = self
            globalSubMenu?.setContentFrame(contentFrame: subFrame)
            globalSubMenu?.frame = stackView4?.superview?.frame ?? .zero

            stackView4?.superview?.addSubview(globalSubMenu!)
            ENKeyButtonEffectManager.shared.excute()
        }
    }
    
}


extension ENQwertyManager:ENKeyboardGlobalSubMenuViewDelegate {
    
    public func globalSubMenuTapped(menu: ENKeyboardGlobalSubMenuView, action: ENKeyboardGlobalSubMenuViewAction) {
        menu.removeFromSuperview()
        
        switch action {
        case .toEnglish:
            self.shiftButtonState = .normal
            self.isAlphabet = true
            self.changeKeyboardToLetterKeys()
            break
            
        case .toKorean:
            self.shiftButtonState = .normal
            self.isAlphabet = false
            self.changeKeyboardToLetterKeys()
            break
            
        case .changeKeyboard:
            delegate?.handleInputModeList(manager: self)
            break
        }
        
        
    }
}





//MARK:- ENKeyButtonViewDelegate Method
extension ENQwertyManager: ENKeyButtonViewDelegate {
    
    func enKeyPressedTouchUp(_ sender: ENKeyButtonView?) {
        guard let targetView = sender else { return }
        guard let originalKey = sender?.original, let keyToDisplay = sender?.keyToDisplay else {return}
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            targetView.backgroundImageView.isHighlighted = false
        })
        
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
            
        case "123":
            changeKeyboardToNumberKeys()
            
        case "letter":
            changeKeyboardToLetterKeys()
            
        case "#+=":
            changeKeyboardToSymbolKeys()
            
        case "⇧":
            shiftButtonState = shiftButtonState == .normal ? .shift : .normal
//            loadKeys()
            changeKeys()
        default:
//            preview.removeFromSuperview()

            preview.hidePreview(from: sender)
            
         
            delegate?.textInputted(manager: self, text: keyToDisplay)
            automata?.makeTextWith(inputed: keyToDisplay)
            // MARK: 쌍자음 다음입력된 모음 순서가 반대로 나오는 문제 수정 / 추가 된 날짜 : 2024 01 24 / 손재민
            ///뷰를 재설정 하는 부분이 오래걸리기 떄문에 쌍자음을 입력하고 다음 키를 입력하면 뷰 설정동안 입력이 완료되지 않아 따 > ㅏㄸ 이렇게 나오게됨. 뷰 설정을 입력 다음으로 이동하면 해결됨
            if shiftButtonState == .shift {
                shiftButtonState = .normal
//                loadKeys()
                changeKeys()
            }
        }
    }
    
    
    
    func enKeyMultiPress(_ sender: ENKeyButtonView?) {
        guard let originalKey = sender?.original else {return}
        
        if (originalKey == "⇧") {
            shiftButtonState = .caps
//            loadKeys()
            changeKeys()
        }
    }
    
    
    
    func enKeyTouchDown(_ sender: ENKeyButtonView?) {
        if !(UserDefaults.enKeyboardGroupStandard?.useKeyboardButtonValuePreview() ?? false) {
            return
        }
        if (sender?.isSpecial ?? true) || sender?.original == "space" {
            return
        }
        
        stackView1?.superview?.addSubview(preview)
        preview.labelText.text = sender?.keyToDisplay ?? ""
        
        // MARK: - 프리뷰 글자 색상 변경 / 추가 된 날짜 : 2023 08 14 / xim
        // 임의의 point 위치 생성
        let point: CGPoint = CGPoint(x: 30, y: 30)
        
        // 백그라운드 이미지에서 임의의 point 의 색상을 구한다.
        // 구해온 색상이 밝은지 어두운지 판단한다.

        
        
        if let tempColor = keyboardTheme.backgroundImage?.getPixelColor(pos: point) {
            if tempColor.isLight() {
                preview.labelText.textColor = .black
            } else {
                preview.labelText.textColor = .white
            }
        }
        
        if (sender?.isPadding ?? false) {
            let temp = keys.filter({ key in
                let original = (key as? ENKeyButtonView)?.original
                return original == "a" || original == "ㅁ" || original == "l" || original == "ㅣ"
            })
            
            if temp.count > 0 {
                preview.updateFrame(with: (temp[0] as? ENKeyButtonView))
            }
        }
        else {
            preview.updateFrame(with: sender)
        }
    }
    
    
}
