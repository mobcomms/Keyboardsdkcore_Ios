//
//  ENAutomata.swift
//  KeyboardSDKCore
//
//  Created by cashwalkKeyboard on 2021/05/04.
//
import Foundation
import UIKit


/// 오토마타 기본 클래스
open class ENAutomata: NSObject {
    
    var proxy: UITextDocumentProxy?
    var customTextField:UITextField? = nil {
        didSet {
            clearInputed()
        }
    }
    
    
    public init(with proxy: UITextDocumentProxy?) {
        super.init()
        
        self.proxy = proxy
    }
    
    open func clearInputed() {}
    open func makeTextWith(inputed: String?) {}
    
    
    
    func deleteBackword() {
        if let customTextField = customTextField {
            customTextField.deleteBackward()
        }
        else {
            proxy?.deleteBackward()
        }
    }
    
    func insertText(_ text: String) {
        if let customTextField = customTextField {
            customTextField.insertText(text)
        }
        else {
            proxy?.insertText(text)
        }
    }
    
    func checkBeforeInputed(_ cursorChangeChecker: String) {
        var before = ""
        
        if let customTextField = customTextField {
            before = customTextField.text ?? ""
        }
        else {
            before = proxy?.documentContextBeforeInput ?? ""
        }
        
        
        if before.isEmpty || !before.hasSuffix(cursorChangeChecker) {
            clearInputed()
        }
    }
}

