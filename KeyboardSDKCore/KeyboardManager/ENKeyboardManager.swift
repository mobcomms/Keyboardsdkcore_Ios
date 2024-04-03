//
//  ENKeyboardManager.swift
//  KeyboardSDKCore
//
//  Created by cashwalkKeyboard on 2021/05/04.
//

import Foundation
import UIKit



public protocol ENKeyboardManagerDelegate: AnyObject {
    func handleInputModeList(manager:ENKeyboardManager)
    func textInputted(manager:ENKeyboardManager, text:String?)
    func showEmojiView(manager:ENKeyboardManager)
}



/**
 키보드 버튼의 구성과 사용하는 Automata를 결정하여 실질적인 키보드의 동작을 명세하는 곳.
 본 클래스 파일을 상속하여 키보드 종류에 맞는 UI와 동작을 구현한다.
 */

open class ENKeyboardManager: NSObject {
    
    var proxy: UITextDocumentProxy?             //UIInputViewController의 proxy
    var needsInputModeSwitchKey: Bool = true
    var automata: ENAutomata?
    
    var keyboardFrame:CGRect = .zero
    public var keyboardTheme:ENKeyboardTheme = ENKeyboardTheme() {
        didSet {
            themeChanged()
            preview.changeTheme(theme: keyboardTheme)
        }
    }
    
    var customTextField:UITextField? = nil {
        didSet {
            automata?.customTextField = customTextField
        }
    }
    
    var globalSubMenu:ENKeyboardGlobalSubMenuView? = nil
    var preview:ENKeyboardPreView = ENKeyboardPreView(frame: .zero, theme: nil)
    
    public var nextKeyboardButton: UIView?
    
    public var stackView1: UIStackView?         //키보드 첫번째 라인
    public var stackView2: UIStackView?         //키보드 두번째 라인
    public var stackView3: UIStackView?         //키보드 세번째 라인
    public var stackView4: UIStackView?         //키보드 네번째 라인
    public var stackView5: UIStackView?         //키보드 다섯번째 라인
    
    
    var keys: [UIView] = []
    var paddingViews: [UIView] = []
    
    var backspaceTimer: Timer?
    
    // MARK: 디폴트 값 false 로 한글 기준으로 함. / 수정 된 날짜 : 2023 08 10 / xim
    public var isAlphabet:Bool = false
    public var keyboardState: ENKeyboardState = .letter
    var shiftButtonState:ENShiftButtonState = .normal
    
    public weak var delegate:ENKeyboardManagerDelegate?
    
    
    private var deleteSpeedUpTime:Double = 0.0
    
    /**
     초기화 메소드
     
     - parameter proxy: UIInputViewController의 proxy
     - parameter needsInputModeSwitchKey: UIInputViewController의 needsInputModeSwitchKey.  Global 버튼의 동작 및 UI표시 여부를 결정하기 위함
     */
    public init(with proxy: UITextDocumentProxy?, needsInputModeSwitchKey:Bool) {
        super.init()
        self.proxy = proxy
        self.needsInputModeSwitchKey = needsInputModeSwitchKey
        
        ENKeyButtonEffectManager.shared.stateUpdate()
        
    }
    
    /**
     키보드의 각 버튼들을 재구성 한다.
     */
    open func loadKeys(_ size: CGSize = .zero) {}
    
    /**
     키보드 프레임을 업데이트 한다
     */
    open func updateKeyboardFrame(frame:CGRect) {
        self.keyboardFrame = frame
    }
    
    /**
     변경된 테마를 적용한다.
     */
    open func themeChanged() {}
    
    
    func handlDeleteButtonPressed() {}
    
    
    open func unloadKeyboard() {
        keys.forEach{
            ($0 as? ENKeyButtonView)?.backgroundImageView.image = nil
            ($0 as? ENKeyButtonView)?.backgroundImageView.highlightedImage = nil
            ($0 as? ENKeyButtonView)?.iconImageView.image = nil
            $0.removeFromSuperview()
        }
        
        paddingViews.forEach{
            ($0 as? ENKeyButtonView)?.backgroundImageView.image = nil
            ($0 as? ENKeyButtonView)?.backgroundImageView.highlightedImage = nil
            ($0 as? ENKeyButtonView)?.iconImageView.image = nil
            $0.removeFromSuperview()
        }
    }
    
    
    @objc func keyLongPressed(_ gesture: UILongPressGestureRecognizer){
        if gesture.state == .began {
            if let targetView = gesture.view {
                for inner in targetView.subviews {
                    if let img = inner as? UIImageView {
                        img.isHighlighted = true
                    }
                }
            }
            deleteSpeedUpTime = 2.5
            backspaceTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] (timer) in
                guard let self else { return }
                
                if self.deleteSpeedUpTime > 0 {
                    self.deleteSpeedUpTime -= 0.1
                    self.handlDeleteButtonPressed()
                }
                else {
                    // 10회 반복...
                    // 속도와 관련하여 미미한 차이라도 더 빠르게 하기 위해 반복문을 사용하지 않음.
                    self.handlDeleteButtonPressed() //1
                    self.handlDeleteButtonPressed() //2
                    self.handlDeleteButtonPressed() //3
                    self.handlDeleteButtonPressed() //4
                    self.handlDeleteButtonPressed() //5
                    self.handlDeleteButtonPressed() //6
                    self.handlDeleteButtonPressed() //7
                    self.handlDeleteButtonPressed() //8
                    self.handlDeleteButtonPressed() //9
                    self.handlDeleteButtonPressed() //10
                }
                
            }
        } else if gesture.state == .ended || gesture.state == .cancelled {
            if let targetView = gesture.view {
                for inner in targetView.subviews {
                    if let img = inner as? UIImageView {
                        img.isHighlighted = false
                    }
                }
            }
            backspaceTimer?.invalidate()
            backspaceTimer = nil
        }
    }
    
    
    var longPresedPosition:CGPoint = .zero
    
    @objc func spaceKeyLongPressed(sender: UILongPressGestureRecognizer) {
        
        switch sender.state {
        case .began:
            DHLogger.log("start")
            longPresedPosition = sender.location(in: sender.view)
            
            shiftButtonState = .normal
            keys.forEach {
                ($0 as? ENKeyButtonView)?.updateByTheme(isCursorChangeMode: true)
                ($0 as? EN10KeyButtonView)?.updateByTheme(isCursorChangeMode: true)
            }
            ENKeyButtonEffectManager.shared.excute()
            return
            
        case .changed:
            let position = sender.location(in: sender.view)
            let offset = (position.x - longPresedPosition.x) / 2.5
            
            if offset >= 1 || offset <= -1 {
                proxy?.adjustTextPosition(byCharacterOffset: Int(offset))
                longPresedPosition = position
            }
            return
            
        case .ended:
            DHLogger.log("end")
            keys.forEach {
                ($0 as? ENKeyButtonView)?.updateByTheme(isCursorChangeMode: false)
                ($0 as? EN10KeyButtonView)?.updateByTheme(isCursorChangeMode: false)
            }
            return
            
        default:
            return
        }
    }
}
