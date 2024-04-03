//
//  ENKeyButtonView.swift
//  KeyboardSDKCore
//
//  Created by enlipleIOS1 on 2021/06/02.
//

import Foundation
import UIKit


/// ENKeyButtonView Delegate Protocol
protocol ENKeyButtonViewDelegate: AnyObject {
    func enKeyPressedTouchUp(_ sender: ENKeyButtonView?)
    func enKeyTouchDown(_ sender: ENKeyButtonView?)
    func enKeyMultiPress(_ sender: ENKeyButtonView?)
}

class ENKeyButtonView: UIView {
    
    /// 키보드 자판에 대한 값
    var original: String = ""
    
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
    
    
    /// 키보드 자판 구성에서 몇번째 열의 자판인지 확인하기 위함
    var row:Int = 0
    
    /// 쉬프트 버튼 상태에 따라 자판 텍스트 표기가 다른 경우에 대응하기 위함
    var shiftButtonState:ENShiftButtonState = .normal
    
    /// Global 버튼의 동작을 위해 해당 값 필요
    var needsInputModeSwitchKey:Bool = true
    
    /// ENKeyButtonViewDelegate
    weak var delegate: ENKeyButtonViewDelegate?
    
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
    init(key: String, shiftButtonState:ENShiftButtonState, theme:ENKeyboardTheme = ENKeyboardTheme(), isPadding:Bool = false) {
        super.init(frame: .zero)
        
        self.backgroundColor = .clear
        self.tintColor = .clear
        
        self.isPadding = isPadding
        
        initView()
        
        let capsKey = key.capitalized
        let keyToDisplay = shiftButtonState == .normal ? key : capsKey
        
        self.original = key
        self.keyToDisplay = keyToDisplay
        self.isSpecial = false
        self.shiftButtonState = shiftButtonState

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
        self.update(key: key, shiftButtonState: shiftButtonState)
        
        self.contentMode = .center
        self.clipsToBounds = true
        
        backgroundImageView.isHidden = isPadding
        titleLabel.isHidden = isPadding
        iconImageView.isHidden = isPadding
        
        if keyboardTheme.isPhotoTheme {
            backgroundImageView.backgroundColor = keyboardTheme.themeColors.nor_btn_color
            backgroundImageView.image = nil
//            backgroundImageView.highlightedImage = nil
            self.backgroundImageView.layer.applyRounding(cornerRadius: 5, borderColor: .clear, borderWidth: 0.0, masksToBounds: true)
        }
        else {
            backgroundImageView.image = keyboardTheme.keyNormalBackgroundImage
            backgroundImageView.highlightedImage = keyboardTheme.keyPressedBackgroundImage
            self.backgroundImageView.layer.applyRounding(cornerRadius: 0, borderColor: .clear, borderWidth: 0.0, masksToBounds: false)
        }
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
        backgroundImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        
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
    func update(key: String, shiftButtonState:ENShiftButtonState) {
        titleLabel.textColor = keyboardTheme.themeColors.key_text
        titleLabel.highlightedTextColor = keyboardTheme.themeColors.key_text
        
        let capsKey = key.capitalized
        let keyToDisplay = shiftButtonState == .normal ? key : capsKey
        self.keyToDisplay = keyToDisplay
        self.original = keyToDisplay

        titleLabel.text = keyToDisplay
    }
    
    
    /// 키보드 자판 종류에 따라 폰트 사이즈를 변경해 준다.
    private func updateFontSize() {
        
        if isSpecial {
            if original == "☺︎" {
                titleLabel.font = UIFont.systemFont(ofSize: 30.0, weight: .medium)
            }
            else {
                self.titleLabel.font = UIFont.systemFont(ofSize: 17.0, weight: .medium)
            }
        }
        else {
            self.titleLabel.font = UIFont.systemFont(ofSize: 23.0, weight: .regular)
        }
    }
    
    
    /// 새로운 테마 적용 및 모드 변경으로 인한 버튼 구성 변경시 호출
    /// - Parameter isCursorChangeMode: 커서 위치를 변경하는 모드로 진입하여 업데이트시 true,  그외의 경우 false이다.  기본값은 false
    func updateByTheme(isCursorChangeMode:Bool = false) {
        if keyboardTheme.isPhotoTheme {
            backgroundImageView.backgroundColor = keyboardTheme.themeColors.nor_btn_color
            backgroundImageView.image = nil
//            backgroundImageView.highlightedImage = nil
            
            self.backgroundImageView.layer.applyRounding(cornerRadius: 5, borderColor: .clear, borderWidth: 0.0, masksToBounds: true)
        }
        else {
            backgroundImageView.image = keyboardTheme.keyNormalBackgroundImage
            backgroundImageView.highlightedImage = keyboardTheme.keyPressedBackgroundImage
            self.backgroundImageView.layer.applyRounding(cornerRadius: 0, borderColor: .clear, borderWidth: 0.0, masksToBounds: false)
        }
        
        
        titleLabel.textColor = keyboardTheme.themeColors.key_text
        titleLabel.highlightedTextColor = keyboardTheme.themeColors.key_text
        
        update(key: original, shiftButtonState: .normal)
        
        if isSpecial {
            titleLabel.text = ""
            
            if keyboardTheme.isPhotoTheme {
                backgroundImageView.backgroundColor = keyboardTheme.themeColors.sp_btn_color
                backgroundImageView.image = nil
//                backgroundImageView.highlightedImage = nil
                self.backgroundImageView.layer.applyRounding(cornerRadius: 5, borderColor: .clear, borderWidth: 0.0, masksToBounds: true)
            }
            else {
                backgroundImageView.image = keyboardTheme.specialKeyNormalBackgroundImage
                backgroundImageView.highlightedImage = keyboardTheme.specialKeyPressedBackgroundImage
                self.backgroundImageView.layer.applyRounding(cornerRadius: 0, borderColor: .clear, borderWidth: 0.0, masksToBounds: false)
            }
            
            titleLabel.textColor = keyboardTheme.themeColors.specialKeyTextColor
            titleLabel.highlightedTextColor = keyboardTheme.themeColors.specialKeyTextColor
            
            
            if original == "⇧" {
                iconImageView.image = keyboardTheme.keyShiftNormalImage
                
                if shiftButtonState != .normal {
                    iconImageView.image = keyboardTheme.keyShiftPressedImage
                }
                
                if shiftButtonState == .caps {
                    iconImageView.image = keyboardTheme.keyCapslockImage
                    self.isSelected = true
                }
            }
            if original == "🌐" && titleLabel.text != "한영"{
                if needsInputModeSwitchKey {
                    iconImageView.image = keyboardTheme.keyGlobalImage
                }
                else {
                    iconImageView.image = keyboardTheme.keyGlobalImage
                    titleLabel.text = "한영"
                    titleLabel.isHidden = true
                }
            }
            
            if original == "letter" {
                titleLabel.text = (isAlphabet ? "ABC":"한글")
            }
            
            if original == "123" {
                titleLabel.text = original
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
                iconImageView.image = keyboardTheme.keyDeleteImage
            }
            if original == "⮐" {
                iconImageView.image = keyboardTheme.keyEnterImage
            }
            if original == "#+=" {
                iconImageView.image = keyboardTheme.keySpecialImage
            }
        }
        
        if original == "space" {
            titleLabel.text = ""
            iconImageView.image = keyboardTheme.keySpaceImage
        }
        
        
        if isCursorChangeMode {
            iconImageView.image = nil
            titleLabel.text = ""
        }
        
    }
    
    
    private func updateByBasicTheme(isCursorChangeMode: Bool) {
        
    }
    
    
    
    
    @objc func excuteGesture(gesture: UIGestureRecognizer) {
        switch gesture.state {
        case .began:

            if ENKeyboardSDKCore.shared.lastGesture != nil {
                ENKeyboardSDKCore.shared.lastGesture?.state = .ended
                ENKeyboardSDKCore.shared.lastGesture = nil
            }
            ENKeyboardSDKCore.shared.lastGesture = gesture
            backgroundImageView.isHighlighted = true
            titleLabel.isHighlighted = true
            delegate?.enKeyTouchDown(self)
            break
        
        case .ended:
            if ENKeyboardSDKCore.shared.lastGesture != nil {
                ENKeyboardSDKCore.shared.lastGesture = nil
            }
            self.isSelected = false
            backgroundImageView.isHighlighted = false
            titleLabel.isHighlighted = false
            
            ENKeyButtonEffectManager.shared.excute()
            delegate?.enKeyPressedTouchUp(self)
            break
            
        default:
            return
        }
    }
    
    
    @objc func excuteTapGesutre(gesture: UITapGestureRecognizer) {
//        backgroundImageView.transform = CGAffineTransform.identity.translatedBy(x: 0, y: 2.0)
        backgroundImageView.isHighlighted = true
        ENKeyButtonEffectManager.shared.excute()
        delegate?.enKeyPressedTouchUp(self)
    }
    
    @objc func excuteLongPressGesture(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            backgroundImageView.isHighlighted = true
//            backgroundImageView.transform = CGAffineTransform.identity.translatedBy(x: 0, y: 2.0)
            ENKeyButtonEffectManager.shared.excute()
            delegate?.enKeyMultiPress(self)
        }
    }
    
}



class ENTouchDownGestureRecognizer: UIGestureRecognizer {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        state = .began
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)

    }
    override func touchesEstimatedPropertiesUpdated(_ touches: Set<UITouch>) {
        super.touchesEstimatedPropertiesUpdated(touches)
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        // MARK:  cancelled로 들어오면 입력이 안되기 떄문에 end로 치환 / 추가 된 날짜 : 2024 01 24 / 손재민
        super.touchesCancelled(touches, with: event)
        state = .ended

    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)

        self.state = .ended
    }
}
