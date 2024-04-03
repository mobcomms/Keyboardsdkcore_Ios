//
//  EN10KeyButtonView.swift
//  KeyboardSDKCore
//
//  Created by cashwalkKeyboard on 2021/09/09.
//

import Foundation
import UIKit


protocol EN10KeyButtonViewDelegate: AnyObject {
    func enKeyPressedTouchUp(_ sender: EN10KeyButtonView?)
    func enKeyTouchDown(_ sender: EN10KeyButtonView?)
    func enKeyMultiPress(_ sender: EN10KeyButtonView?)
}


class EN10KeyButtonView: UIView {
    
    /// 키보드 자판에 대한 값
    var original: String = ""
    
    /// 키보드 서브 자판 값
    var subKeys: String = ""
    
    /// 현재 상황에 따라 자판에 출력될 텍스트 값
    var keyToDisplay: String = ""
    
    /// 알파벳 표시 여부
    var isAlphabet: Bool = false
    
    /// 특수키 여부
    var isSpecial: Bool = false {
        didSet {
            updateFontSize()
        }
    }
    
    
    /// 키보드 상태값
    var keyboardState: ENKeyboardState = .letter
    
    
    /// 키보드 자판 구성에서 몇번째 열의 자판인지 확인하기 위함
    var row:Int = 0
    
    /// 쉬프트 버튼 상태에 따라 자판 텍스트 표기가 다른 경우에 대응하기 위함
    var shiftButtonState:ENShiftButtonState = .normal
    
    /// Global 버튼의 동작을 위해 해당 값 필요
    var needsInputModeSwitchKey:Bool = true
    
    /// ENKeyButtonViewDelegate
    weak var delegate: EN10KeyButtonViewDelegate?
    
    /// 키보드 테마 구성을 위한 값
    var keyboardTheme:ENKeyboardTheme = ENKeyboardTheme() {
        didSet {
            updateByTheme()
        }
    }
    
    
    
    var titleLabel:UILabel = UILabel()
    var iconImageView:UIImageView = UIImageView()
    var backgroundImageView:UIImageView = UIImageView()
    
    var isSelected:Bool = false
    var isPadding:Bool = false
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    deinit {
    }
    
    
    /// 전달받은 값을 통해 키보드 자판 버튼을 구성한다.
    /// - Parameters:
    ///   - key: 키보드 자판에 표시할 텍스트.  종류에 따라서는 텍스트 대신 전달받은 테마 객체에서 이미지를 활용하기도 한다.
    ///   - shiftButtonState: 쉬프트 버튼의 현재 상태값
    ///   - theme: 키보드 자판에 적용할 테마 객체
    init(key: String, subKey:String, shiftButtonState:ENShiftButtonState, keyboardState: ENKeyboardState, theme:ENKeyboardTheme = ENKeyboardTheme(), isPadding:Bool = false) {
        super.init(frame: .zero)
        
        self.backgroundColor = .clear
        self.tintColor = .clear
        
        self.isPadding = isPadding
        
        initView()
        
        let capsKey = key.uppercased()
        let keyToDisplay = shiftButtonState == .normal ? key : capsKey
        
        self.original = key
        self.subKeys = subKey
        self.keyToDisplay = "\(keyToDisplay)\(subKey)"
        self.isSpecial = false
        self.shiftButtonState = shiftButtonState
        self.keyboardState = keyboardState

        if original == "⇧" {
            self.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(excuteTapGesutre(gesture:))))
            self.addGestureRecognizer(UILongPressGestureRecognizer.init(target: self, action: #selector(excuteLongPressGesture(gesture:))))
        }
        else if original == "space" {
            self.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(excuteTapGesutre(gesture:))))
        }
        else if original == "⌫" {
            self.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(excuteTapGesutre(gesture:))))
        }
        else if original != "🌐" {
            self.addGestureRecognizer(ENTouchDownGestureRecognizer.init(target: self, action: #selector(excuteGesture(gesture:))))
        }
        
        
        self.keyboardTheme = theme
        self.update(key: key, subKey: subKey, shiftButtonState: shiftButtonState)
        
        self.contentMode = .center
        self.clipsToBounds = true
        
        backgroundImageView.isHidden = isPadding
        titleLabel.isHidden = isPadding
        iconImageView.isHidden = isPadding
        
        if keyboardTheme.isPhotoTheme {
            backgroundImageView.backgroundColor = keyboardTheme.themeColors.nor_btn_color
            backgroundImageView.image = nil
            backgroundImageView.highlightedImage = nil
            self.backgroundImageView.layer.applyRounding(cornerRadius: 5, borderColor: .clear, borderWidth: 0.0, masksToBounds: true)
        }
        else {
            backgroundImageView.image = keyboardTheme.keyNormalBackgroundImage
            backgroundImageView.highlightedImage = keyboardTheme.keyPressedBackgroundImage
            self.backgroundImageView.layer.applyRounding(cornerRadius: 0, borderColor: .clear, borderWidth: 0.0, masksToBounds: false)
        }
        
        updateKeyboardTypeButtons()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    
    private func initView() {
        updateFontSize()
        backgroundImageView.contentMode = .scaleToFill
        iconImageView.contentMode = .center
        titleLabel.textAlignment = .center
        
        backgroundImageView.isUserInteractionEnabled = false
        iconImageView.isUserInteractionEnabled = false
        titleLabel.isUserInteractionEnabled = false
        
        self.addSubview(backgroundImageView)
        self.addSubview(iconImageView)
        self.addSubview(titleLabel)
        
        addDefaultConstraint()
    }
    
    func addDefaultConstraint() {
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 2.5).isActive = true
        backgroundImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -2.5).isActive = true
        backgroundImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 2.5).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -2.5).isActive = true
        
        iconImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        iconImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        iconImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        iconImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        
        titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true

    }
    
    
    
    /// 버튼의 상태를 업데이트 한다.
    /// - Parameters:
    ///   - key: 자판에 표시할 텍스트
    ///   - shiftButtonState: 현재 쉬프트 버튼의 상태값
    func update(key: String, subKey:String, shiftButtonState:ENShiftButtonState) {
        if isSpecial {
            titleLabel.textColor = keyboardTheme.themeColors.specialKeyTextColor
            titleLabel.highlightedTextColor = keyboardTheme.themeColors.specialKeyTextColor
        }
        else {
            titleLabel.textColor = keyboardTheme.themeColors.key_text
            titleLabel.highlightedTextColor = keyboardTheme.themeColors.key_text
        }
        
        
        let capsKey = key.uppercased()
        let keyToDisplay = shiftButtonState == .normal ? key : capsKey
        
        let showingKey = "\(keyToDisplay)\n\(subKey)"
        if subKey.isEmpty {
            titleLabel.text = showingKey
            titleLabel.numberOfLines = 1
        }
        else {
            let attributedString = NSMutableAttributedString(string:showingKey , attributes: [
                .font: UIFont.systemFont(ofSize: self.titleLabel.font.pointSize / 2)
            ])
            attributedString.addAttribute(.font, value: self.titleLabel.font!, range: NSRange(location: 0, length: 1))
            titleLabel.attributedText = attributedString
            titleLabel.numberOfLines = 0
        }
        
        updateKeyboardTypeButtons()
    }
    
    
    /// 키보드 자판 종류에 따라 폰트 사이즈를 변경해 준다.
    private func updateFontSize() {
        if original == "☺︎" {
            titleLabel.font = UIFont.systemFont(ofSize: 30.0, weight: .medium)
        }
        else if subKeys.isEmpty {
            self.titleLabel.font = UIFont.systemFont(ofSize: 17.0, weight: .medium)
        }
    }
    
    
    /// 새로운 테마 적용 및 모드 변경으로 인한 버튼 구성 변경시 호출
    /// - Parameter isCursorChangeMode: 커서 위치를 변경하는 모드로 진입하여 업데이트시 true,  그외의 경우 false이다.  기본값은 false
    func updateByTheme(isCursorChangeMode:Bool = false) {
        if isSpecial {
            titleLabel.text = ""
            
            if keyboardTheme.isPhotoTheme {
                backgroundImageView.backgroundColor = keyboardTheme.themeColors.sp_btn_color
                backgroundImageView.image = nil
                backgroundImageView.highlightedImage = nil
                self.backgroundImageView.layer.applyRounding(cornerRadius: 5, borderColor: .clear, borderWidth: 0.0, masksToBounds: true)
            }
            else {
                backgroundImageView.image = keyboardTheme.specialKeyNormalBackgroundImage
                backgroundImageView.highlightedImage = keyboardTheme.specialKeyPressedBackgroundImage
                self.backgroundImageView.layer.applyRounding(cornerRadius: 0, borderColor: .clear, borderWidth: 0.0, masksToBounds: false)
            }
            
            titleLabel.textColor = keyboardTheme.themeColors.specialKeyTextColor
            titleLabel.highlightedTextColor = keyboardTheme.themeColors.specialKeyTextColor
        }
        else {
            if keyboardTheme.isPhotoTheme {
                backgroundImageView.backgroundColor = keyboardTheme.themeColors.nor_btn_color
                backgroundImageView.image = nil
                backgroundImageView.highlightedImage = nil
                
                self.backgroundImageView.layer.applyRounding(cornerRadius: 5, borderColor: .clear, borderWidth: 0.0, masksToBounds: true)
            }
            else {
                backgroundImageView.image = keyboardTheme.keyNormalBackgroundImage
                backgroundImageView.highlightedImage = keyboardTheme.keyPressedBackgroundImage
                self.backgroundImageView.layer.applyRounding(cornerRadius: 0, borderColor: .clear, borderWidth: 0.0, masksToBounds: false)
            }
            
            
            titleLabel.textColor = keyboardTheme.themeColors.key_text
            titleLabel.highlightedTextColor = keyboardTheme.themeColors.key_text
        }
        
        update(key: original, subKey: subKeys, shiftButtonState: .normal)
        
        if isCursorChangeMode {
            iconImageView.image = nil
            titleLabel.text = ""
        }
        else {
            if original == "⇧" {
                titleLabel.text = ""
                
                var image = keyboardTheme.keyShiftNormalImage?.withRenderingMode(.alwaysTemplate)


                if shiftButtonState != .normal {
                    image = keyboardTheme.keyShiftPressedImage?.withRenderingMode(.alwaysTemplate)
                }
                
                if shiftButtonState == .caps {
                    image = keyboardTheme.keyCapslockImage?.withRenderingMode(.alwaysTemplate)
                    self.isSelected = true
                }
                iconImageView.image = image

                iconImageView.tintColor = ENKeyboardThemeManager.shared.loadedTheme?.themeColors.key_text

            }
            if original == "🌐" && titleLabel.text != "한영"{
                if needsInputModeSwitchKey {
                    iconImageView.image = keyboardTheme.keyGlobalImage
                } else {
                    iconImageView.image = keyboardTheme.keyGlobalImage
                    titleLabel.text = "한영"
                    titleLabel.isHidden = true
                }
            }
            
            if original == "☺︎" {
                if keyboardTheme.isPhotoTheme {
                    iconImageView.image = nil
                    titleLabel.text = original
                }
                else {
                    iconImageView.image = keyboardTheme.keyEmojiIcon
                    titleLabel.text = ""
                }
            }
            
            if original == "⌫" {
                titleLabel.text = ""
                iconImageView.image = keyboardTheme.keyDeleteImage
            }
            if original == "⮐" {
                titleLabel.text = ""
                iconImageView.image = keyboardTheme.keyEnterImage
            }
            
            if original == "space" {
                titleLabel.text = ""
                iconImageView.image = keyboardTheme.keySpaceImage
            }
        }
        
        updateKeyboardTypeButtons()
    }
    
    
    private func updateByBasicTheme(isCursorChangeMode: Bool) {
    }
    
    
    
    
    
    @objc func excuteGesture(gesture: UIGestureRecognizer) {
        
        switch gesture.state {
        
        case .began:
            backgroundImageView.isHighlighted = true
            titleLabel.isHighlighted = true
            delegate?.enKeyTouchDown(self)
            break
        
        
        case .ended:
            self.isSelected = false
            backgroundImageView.isHighlighted = false
            titleLabel.isHighlighted = false
            
            ENKeyButtonEffectManager.shared.excute()
            delegate?.enKeyPressedTouchUp(self)
            break
            
        default:
            return
        }
        
        updateKeyboardTypeButtons()
    }
    
    
    @objc func excuteTapGesutre(gesture: UITapGestureRecognizer) {
        ENKeyButtonEffectManager.shared.excute()
        delegate?.enKeyPressedTouchUp(self)
        updateKeyboardTypeButtons()
    }
    
    @objc func excuteLongPressGesture(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            ENKeyButtonEffectManager.shared.excute()
            delegate?.enKeyMultiPress(self)
            updateKeyboardTypeButtons()
        }
        
    }
    
    
    func updateKeyboardTypeButtons() {
        backgroundImageView.isHighlighted = false
        titleLabel.isHighlighted = false
        
        
        switch original {
        case "#123":
            if keyboardState != .letter {
                backgroundImageView.isHighlighted = true
                titleLabel.isHighlighted = true
            }

        case "ABC":
            if keyboardState == .letter && isAlphabet {
                backgroundImageView.isHighlighted = true
                titleLabel.isHighlighted = true
            }

        case "한글":
            if keyboardState == .letter && !isAlphabet {
                backgroundImageView.isHighlighted = true
                titleLabel.isHighlighted = true
            }

        default:
            break
        }
    }
}
