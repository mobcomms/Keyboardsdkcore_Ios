//
//  ENKoreanAutomata.swift
//  KeyboardSDKCore
//
//  Created by cashwalkKeyboard on 2021/05/04.
//

import Foundation
import UIKit


/// 한글 기본 오토마타.  
public class ENKoreanAutomata: ENAutomata, ENCombinKorean {
    
    var realInputedChars: [Character] = []
    var charsForMakeTexts: [Character] = []
    var checkerChars: [Character] = []
    var cursorChangeChecker: String = ""
    
    
    public override func clearInputed() {
        realInputedChars.removeAll()
        checkerChars.removeAll()
        cursorChangeChecker = ""
    }
    
    public override func makeTextWith(inputed: String?) {
        var index = 0
        var currentPosition: ENHanglePosition = .ChoSung
        
        var makedString:String = ""
        
//        DHLogger.log("start make text while--------------------------------------------------------------------------------------------------------------------------------")
        
        
        while index < charsForMakeTexts.count {
            let curChar = charsForMakeTexts[index]
            let nextChar = (index + 1) < charsForMakeTexts.count ? charsForMakeTexts[index + 1] : Character("a")
//            DHLogger.log("curChar : \(curChar), nextChar : \(nextChar), currentPosition: \(currentPosition)")
            
            switch currentPosition {
            case .ChoSung:
                if isCho(char: nextChar) {      //다음 문자가 초성인 경우
                    if addDoubleChosung(char: curChar, nextChar: nextChar) {
                        index += 2
                        
                        let nextStepChar = index < charsForMakeTexts.count ? charsForMakeTexts[index] : Character("a")  //더블 초성 처리후 다음 문자가 초성인 경우 현재까지 문자로 완료처리. 초성부터 다시 시작
                        if isCho(char: nextStepChar) {
                            makedString.append(makeHangle())
                            currentPosition = .ChoSung
                        }
                        else {
                            currentPosition = .JungSung
                        }
                        
                    }
                    else {
                        //겹치지 않는 초성 두개가 입력된 상황..  다음 문자는 초성으로 처리..
                        makedString.append(curChar)
                        index += 1
                    }
                }
                else {
                    if nextChar == Character("a") { //다음 문자가 없는 경우...
                        //한글 조합 완료 처리..
                        makedString.append(curChar)
                        currentPosition = .ChoSung
                        index += 1
                    }
                    else {      //다음 문자가 있는경우..  중성이다...
                        if isCho(char: curChar) && isJung(char: nextChar) {
                            checkerChars.append(curChar)
                            currentPosition = .JungSung
                            index += 1
                        }
                        else {
                            if checkerChars.count > 0 {
                                makedString.append(makeHangle())
                            }
                            makedString.append(curChar)
                            currentPosition = .ChoSung
                            index += 1
                        }
                        
                    }
                }
                break
                
            case .JungSung:
                if isJung(char: nextChar) {
                    if addDoubleJungSung(char: curChar, nextChar: nextChar) {
                        index += 2
                        currentPosition = .JongSung
                    }
                    else {
                        //겹치지 않는 자음 두개가 입력된 상황, 이전까지 분석된 문자를 이용하여 문자열로 만들어 추가, 추가 입력된 자음은 바로 추가.
                        checkerChars.append(curChar)
                        makedString.append(makeHangle())
                        makedString.append(nextChar)
                        currentPosition = .ChoSung
                        index += 2
                    }
                }
                else {
                    if isJung(char: curChar) {
                        checkerChars.append(curChar)
                        currentPosition = .JongSung
                        index += 1
                    }
                    else {
                        //중성이 아닌경우... 초성으로 다시 시도.
                        currentPosition = .ChoSung
                    }
                }
                break
                
            case .JongSung:
                if !isJong(char: curChar) {
                    //현재 문자가 종성이 아니면 이전까지 입력된 문자로 텍스트 만들고 초성부터 다시 시작.
                    makedString.append(makeHangle())
                    currentPosition = .ChoSung
                }
                else {
                    if isJung(char: nextChar) {
                        //다음 문자가 중성이면 이전까지 입력된 문자로 텍스트 만들고 초성부터 다시 시작.
                        makedString.append(makeHangle())
                        currentPosition = .ChoSung
                    }
                    else {
                        let thirdChar = (index + 2) < charsForMakeTexts.count ? charsForMakeTexts[index + 2] : Character("a")
                        if !isJung(char: thirdChar) && addDoubleJongSung(char: curChar, nextChar: nextChar) {
                            //다다음 문자가 중성이 아니고 다음 문자와 조합이 되는 경우..
                            makedString.append(makeHangle())
                            index += 2
                            currentPosition = .ChoSung
                        }
                        else {      //다다음 문자가 중성이거나 다음 문자와 조합이 되지 않는경우.
                            checkerChars.append(curChar)
                            
                            makedString.append(makeHangle())
                            index += 1
                            currentPosition = .ChoSung
                        }
                    }
                    
                }
                break
                
            }
        }
        
        if !checkerChars.isEmpty {
            makedString.append(makeHangle())
        }
        
        //makedString과 cursorChangeChecker을 비교 차이가 발생한 부분만 append
        var appendString = makedString
        if !cursorChangeChecker.isEmpty {
            if inputed?.isEmpty ?? true {
                if (cursorChangeChecker.count > 1) {
                    deleteBackword()
                }
                cursorChangeChecker = String(cursorChangeChecker.prefix(cursorChangeChecker.count - 1))
            }
            
            if self is ENKoreanQwertyAutomata {
                let suffIndex = makedString.count - cursorChangeChecker.count + 1
                appendString = String(makedString.suffix(suffIndex > 0 ? suffIndex : 1))
                deleteBackword()
            }
            else if self is EN10KeyAutomata {
                let suffIndex = makedString.count - cursorChangeChecker.count + 2
                appendString = String(makedString.suffix(suffIndex > 0 ? suffIndex : 2))
                
                let lastChar = cursorChangeChecker.last ?? "a"
                let willRemove = ((self as? EN10KeyAutomata)?.isChunJiIn(lastChar) ?? false)
                
                if (cursorChangeChecker.count > 1) && (makedString.count > 1 || willRemove) {
                    deleteBackword()
                }
                deleteBackword()
            }
        }
        
        insertText(appendString)

//        DHLogger.log("cursorChangeChecker: \(cursorChangeChecker)")
        
        cursorChangeChecker = makedString
        
//        DHLogger.log("appendString: \(appendString)")
//        DHLogger.log("makedString: \(makedString)")
    }
    
    
    func makeHangle() -> String {
        if checkerChars.count < 2 {
            let ret = checkerChars[0]
            checkerChars.removeAll()
            return String(ret)
        }
        
        let char1 = checkerChars[0]
        let char2 = checkerChars.count > 1 ? checkerChars[1] : Character("a")
        let char3 = checkerChars.count > 2 ? checkerChars[2] : Character("a")
        
        checkerChars.removeAll()
        
        guard let makedHangle = combine(c1: char1, c2: char2, c3: char3) else {
            return ""
        }
        
        return String(makedHangle)
    }
    
    
    func isHangle(inputed: Character) -> Bool {
        return isCho(char: inputed) || isJung(char: inputed) || isJong(char: inputed)
    }
    
    func addDoubleChosung(char:Character, nextChar:Character) -> Bool {
        if char == nextChar {
            switch char {
            case Character("ㄱ"):
                checkerChars.append(Character("ㄲ"))
                return true
                
            case Character("ㄷ"):
                checkerChars.append(Character("ㄸ"))
                return true
                
            case Character("ㅂ"):
                checkerChars.append(Character("ㅃ"))
                return true
                
            case Character("ㅅ"):
                checkerChars.append(Character("ㅆ"))
                return true
                
            case Character("ㅈ"):
                checkerChars.append(Character("ㅉ"))
                return true
                
            default:
                return false
            }
        }
        return false
    }
    
    func addDoubleJungSung(char:Character, nextChar:Character) -> Bool {
        if char == Character("ㅗ") {
            switch nextChar {
            case Character("ㅏ"):
                checkerChars.append(Character("ㅘ"))
                return true
                
            case Character("ㅐ"):
                checkerChars.append(Character("ㅙ"))
                return true
                
            case Character("ㅣ"):
                checkerChars.append(Character("ㅚ"))
                return true
                
            default:
                return false
            }
        }
        else if char == Character("ㅜ") {
            switch nextChar {
            case Character("ㅓ"):
                checkerChars.append(Character("ㅝ"))
                return true
                
            case Character("ㅔ"):
                checkerChars.append(Character("ㅞ"))
                return true
                
            case Character("ㅣ"):
                checkerChars.append(Character("ㅟ"))
                return true
                
            default:
                return false
            }
        }
        else if char == Character("ㅡ") {
            switch nextChar {
            case Character("ㅣ"):
                checkerChars.append(Character("ㅢ"))
                return true
            default:
                return false
            }
        }
        
        return false
    }
    
    func addDoubleJongSung(char:Character, nextChar:Character) -> Bool {
        if char == Character("ㄱ") {
            switch nextChar {
            case Character("ㅅ"):
                checkerChars.append(Character("ㄳ"))
                return true
            default:
                return false
            }
        }
        else if char == Character("ㄴ") {
            switch nextChar {
            case Character("ㅈ"):
                checkerChars.append(Character("ㄵ"))
                return true
                
            case Character("ㅎ"):
                checkerChars.append(Character("ㄶ"))
                return true
                
            default:
                return false
            }
        }
        if char == Character("ㅂ") {
            switch nextChar {
            case Character("ㅅ"):
                checkerChars.append(Character("ㅄ"))
                return true
                
            default:
                return false
            }
        }
        else if char == Character("ㄹ") {
            switch nextChar {
            case Character("ㄱ"):
                checkerChars.append(Character("ㄺ"))
                return true
                
            case Character("ㅁ"):
                checkerChars.append(Character("ㄻ"))
                return true
                
            case Character("ㅂ"):
                checkerChars.append(Character("ㄼ"))
                return true
                
            case Character("ㅅ"):
                checkerChars.append(Character("ㄽ"))
                return true
                
            case Character("ㅌ"):
                checkerChars.append(Character("ㄾ"))
                return true
                
            case Character("ㅍ"):
                checkerChars.append(Character("ㄿ"))
                return true
                
            case Character("ㅎ"):
                checkerChars.append(Character("ㅀ"))
                return true
                
            default:
                return false
            }
        }
        
        return false
    }
    
}
