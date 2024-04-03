//
//  EN10KeyAutomata.swift
//  KeyboardSDKCore
//
//  Created by cashwalkKeyboard on 2021/09/07.
//

import Foundation


public class EN10KeyAutomata: ENKoreanAutomata {
    
    var keyboard: [[String]] = ENConstants.alphabet10Key
    
    public override func makeTextWith(inputed: String?) {
//        DHLogger.log("makeTextWith : \(inputed ?? "")")
        
        
        if inputed == "→" {
            clearInputed()
            return
        }
        
        checkBeforeInputed(cursorChangeChecker)
        
        
        DHLogger.log("init first")
        
        var calcInputed = inputed
        if calcInputed == "ㄱㅋ" {
            calcInputed = "ㄱㅋㄲ"
        }
        if calcInputed == "ㅂㅍ" {
            calcInputed = "ㅂㅍㅃ"
        }
        if calcInputed == "ㅅㅎ" {
            calcInputed = "ㅅㅎㅆ"
        }
        if calcInputed == "ㄷㅌ" {
            calcInputed = "ㄷㅌㄸ"
        }
        if calcInputed == "ㅈㅊ" {
            calcInputed = "ㅈㅊㅉ"
        }
        if calcInputed == "ㅈㅊ" {
            calcInputed = "ㅈㅊㅉ"
        }
        
        if calcInputed == String(ENConstants.keyChun) {
            calcInputed = "\(ENConstants.keyChun)\(ENConstants.keyDoubleChun)"
        }
        
        
        if let inputed = calcInputed, let realInput = roteateInputValue(inputed) {
            realInputedChars.append(realInput)
        }
        
        copyAfterConvertToQwertyType()
        super.makeTextWith(inputed: calcInputed)
    }
    
    func roteateInputValue(_ inputed: String) -> Character? {
        
        let chars = Array<Character>.init(inputed)
        
        guard realInputedChars.count > 0, let last = realInputedChars.last else {
            return chars.first
        }
        
        var retChar:Character? = nil
        for index in 0..<chars.count {
            if chars[index] == last {
                retChar = chars[(index+1) % chars.count]
                break
            }
        }
        
        // MARK: 'ㅡ' 또는 'ㅣ' 가 연속으로 나올 때 처리 (약간 if else 부분 고쳐야함) / 추가 된 날짜 : 2023 08 10 / xim
        if retChar == ENConstants.keyIn {
            
        } else if retChar == ENConstants.keyJi {
            
        } else {
            if let _ = retChar {
                realInputedChars.removeLast()
                for _ in 0..<cursorChangeChecker.count {
                    deleteBackword()
                }
                cursorChangeChecker = ""
                
                copyAfterConvertToQwertyType()
                super.makeTextWith(inputed: nil)
            }
        }
        
        return retChar ?? chars.first
    }
    
    
    func checkValidate(inputed: Character) -> Bool {
        return isHangle(inputed: inputed) || isChunJiIn(inputed)
    }
    
    func isChunJiIn(_ inputed: Character) -> Bool {
        return
            ENConstants.keyChun == inputed ||
            ENConstants.keyDoubleChun == inputed ||
            ENConstants.keyJi == inputed ||
            ENConstants.keyIn == inputed
    }
    
    
    func copyAfterConvertToQwertyType() {
        
        var index = 0
        var stack:[Character] = []
        charsForMakeTexts.removeAll()
        
        while index < realInputedChars.count {
            let char = realInputedChars[index]
            
            if isChunJiIn(char) {
                stack.append(char)
            }
            else {
                // MARK: 구분 되어야 할 모음이 추가 됨에 따라 함수 추가 / 수정 된 날짜 : 2023 08 08 / xim
                while stack.count > 1 {
                    if pattern5Char(stack) {
                        stack.removeFirst()
                        stack.removeFirst()
                        stack.removeFirst()
                        stack.removeFirst()
                        stack.removeFirst()
                    } else if pattern4Char(stack) {
                        stack.removeFirst()
                        stack.removeFirst()
                        stack.removeFirst()
                        stack.removeFirst()
                    } else if pattern3Char(stack) {
                        stack.removeFirst()
                        stack.removeFirst()
                        stack.removeFirst()
                    } else if pattern2Char(stack) {
                        stack.removeFirst()
                        stack.removeFirst()
                    } else if pattern1Char(stack) {
                        stack.removeFirst()
                    }
                }
                if pattern1Char(stack) {
                    stack.removeFirst()
                }
                
                charsForMakeTexts.append(contentsOf: stack)
                charsForMakeTexts.append(char)
                
                stack.removeAll()
            }
            
            index += 1
        }
        
        while stack.count > 1 {
            // MARK: 구분 되어야 할 모음이 추가 됨에 따라 함수 추가 / 수정 된 날짜 : 2023 08 08 / xim
            if pattern5Char(stack) {
                stack.removeFirst()
                stack.removeFirst()
                stack.removeFirst()
                stack.removeFirst()
                stack.removeFirst()
            } else if pattern4Char(stack) {
                stack.removeFirst()
                stack.removeFirst()
                stack.removeFirst()
                stack.removeFirst()
            } else if pattern3Char(stack) {
                stack.removeFirst()
                stack.removeFirst()
                stack.removeFirst()
            } else if pattern2Char(stack) {
                stack.removeFirst()
                stack.removeFirst()
            } else if pattern1Char(stack) {
                stack.removeFirst()
            }
        }
        
        if pattern1Char(stack) {
            stack.removeFirst()
        }
        
        charsForMakeTexts.append(contentsOf: stack)
        
//        DHLogger.log("charsForMakeTexts : \(charsForMakeTexts)")
    }
    
    
    func pattern1Char(_ char:[Character]) -> Bool {   // 4종류 - ㅏ, ㅓ, ㅗ, ㅜ
        guard char.count >= 1 else {
            return false
        }
        
        let temp = char.prefix(1)
        
        if temp.elementsEqual([ENConstants.keyJi]) {
            charsForMakeTexts.append("ㅡ")
            return true
        }
        
        if temp.elementsEqual([ENConstants.keyIn]) {
            charsForMakeTexts.append("ㅣ")
            return true
        }
        
        return false
    }
    
    func pattern2Char(_ char:[Character]) -> Bool {   // 8종류 - ㅏ, ㅓ, ㅗ, ㅜ, ㅑ, ㅕ, ㅛ, ㅠ
        guard char.count >= 2 else {
            return false
        }
        
        let temp = char.prefix(2)
        
        if temp.elementsEqual([ENConstants.keyChun,  ENConstants.keyJi]) {
            charsForMakeTexts.append("ㅗ")
            return true
        }
        
        if temp.elementsEqual([ENConstants.keyJi, ENConstants.keyChun]) {
            charsForMakeTexts.append("ㅜ")
            return true
        }
        
        if temp.elementsEqual([ENConstants.keyIn, ENConstants.keyChun]) {
            charsForMakeTexts.append("ㅏ")
            return true
        }
        
        if temp.elementsEqual([ENConstants.keyChun, ENConstants.keyIn]) {
            charsForMakeTexts.append("ㅓ")
            return true
        }
        
        if temp.elementsEqual([ENConstants.keyIn, ENConstants.keyDoubleChun]) {
            charsForMakeTexts.append("ㅑ")
            return true
        }
        
        if temp.elementsEqual([ENConstants.keyDoubleChun, ENConstants.keyIn]) {
            charsForMakeTexts.append("ㅕ")
            return true
        }
        
        if temp.elementsEqual([ENConstants.keyDoubleChun, ENConstants.keyJi]) {
            charsForMakeTexts.append("ㅛ")
            return true
        }
        
        if temp.elementsEqual([ENConstants.keyJi, ENConstants.keyDoubleChun]) {
            charsForMakeTexts.append("ㅠ")
            return true
        }
        
        return false
    }
    
    // MARK: 'ㅝ' 추가 / 수정 된 날짜 : 2023 08 08 / xim
    func pattern3Char(_ char:[Character]) -> Bool {   // 2종류 - ㅐ, ㅔ, ㅒ, ㅖ 근데 이상함... ㅇ
        guard char.count >= 3 else {
            return false
        }
        
        let temp = char.prefix(3)
        
        if temp.elementsEqual([ENConstants.keyIn, ENConstants.keyChun, ENConstants.keyIn]) {
            charsForMakeTexts.append("ㅐ")
            return true
        }
        
        if temp.elementsEqual([ENConstants.keyChun, ENConstants.keyIn, ENConstants.keyIn]) {
            charsForMakeTexts.append("ㅔ")
            return true
        }
        
        if temp.elementsEqual([ENConstants.keyIn, ENConstants.keyDoubleChun, ENConstants.keyIn]) {
            charsForMakeTexts.append("ㅒ")
            return true
        }
        
        if temp.elementsEqual([ENConstants.keyDoubleChun, ENConstants.keyIn, ENConstants.keyIn]) {
            charsForMakeTexts.append("ㅖ")
            return true
        }
        
        if temp.elementsEqual([ENConstants.keyJi, ENConstants.keyDoubleChun, ENConstants.keyIn]) {
            charsForMakeTexts.append("ㅝ")
            return true
        }
        
        return false
    }
    
    // MARK: 'ㅘ', 'ㅞ' 추가 / 수정 된 날짜 : 2023 08 08 / xim
    func pattern4Char(_ char:[Character]) -> Bool {
        guard char.count >= 4 else {
            return false
        }
        
        let temp = char.prefix(4)
        
        if temp.elementsEqual([ENConstants.keyChun, ENConstants.keyJi, ENConstants.keyIn, ENConstants.keyChun]) {
            charsForMakeTexts.append("ㅘ")
            return true
        }
        
        if temp.elementsEqual([ENConstants.keyJi, ENConstants.keyDoubleChun, ENConstants.keyIn, ENConstants.keyIn]) {
            charsForMakeTexts.append("ㅞ")
            return true
        }
        
        return false
    }
    
    // MARK: 'ㅙ' 추가 / 수정 된 날짜 : 2023 08 08 / xim
    func pattern5Char(_ char:[Character]) -> Bool {
        guard char.count >= 5 else {
            return false
        }
        
        let temp = char.prefix(5)
        
        if temp.elementsEqual([ENConstants.keyChun, ENConstants.keyJi, ENConstants.keyIn, ENConstants.keyChun, ENConstants.keyIn]) {
            charsForMakeTexts.append("ㅙ")
            return true
        }
    
        return false
    }
    
}
