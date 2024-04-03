//
//  ENCombinKorean.swift
//  KeyboardSDKCore
//
//  Created by enlipleIOS1 on 2021/05/06.
//

import Foundation


/*
 입력된 텍스트들을 이용하여 한글을 조합해 준다
 */

/// 입력된 텍스트들중 한글 자모를 확인하여 완성된 형태의 한글로 조합해 준다.
protocol ENCombinKorean {
    var cho:[Character] { get }
    var jung:[Character] { get }
    var jong:[Character] { get }
    
    func isCho(char:Character) -> Bool
    func isJung(char:Character) -> Bool
    func isJong(char:Character) -> Bool
    
    func combine(c1:Character,c2:Character,c3:Character) -> Character?
}



extension ENCombinKorean {
    var cho:[Character] {
        return ["ㄱ","ㄲ","ㄴ","ㄷ","ㄸ","ㄹ","ㅁ","ㅂ","ㅃ","ㅅ","ㅆ","ㅇ","ㅈ","ㅉ","ㅊ","ㅋ","ㅌ","ㅍ","ㅎ"]
    }
    
    var jung:[Character] {
        return ["ㅏ", "ㅐ", "ㅑ", "ㅒ", "ㅓ", "ㅔ", "ㅕ", "ㅖ", "ㅗ", "ㅘ", "ㅙ", "ㅚ", "ㅛ", "ㅜ", "ㅝ", "ㅞ", "ㅟ", "ㅠ", "ㅡ", "ㅢ", "ㅣ"]
    }
    
    var jong:[Character] {
        return [" ", "ㄱ", "ㄲ", "ㄳ", "ㄴ", "ㄵ", "ㄶ", "ㄷ", "ㄹ", "ㄺ", "ㄻ", "ㄼ", "ㄽ", "ㄾ", "ㄿ", "ㅀ", "ㅁ", "ㅂ", "ㅄ", "ㅅ", "ㅆ", "ㅇ", "ㅈ", "ㅊ", "ㅋ", "ㅌ", "ㅍ", "ㅎ"]
    }
    
    
    /// 해당 텍스트가 초성에 해당하는지를 확인한다.
    /// - Parameter char: 초성 여부를 확인할 Character
    /// - Returns: 초성인 경우 true, 그 외의 경우 false
    func isCho(char:Character) -> Bool {
        for i in 0 ..< cho.count {
            if cho[i] == char {
                return true
            }
        }
        return false
    }
    
    /// 해당 텍스트가 중성(모음)에 해당하는지를 확인한다.
    /// - Parameter char: 중성(모음) 여부를 확인할 Character
    /// - Returns: 중성(모음)인 경우 true, 그 외의 경우 false
    func isJung(char:Character) -> Bool {
        for i in 0 ..< jung.count {
            if jung[i] == char {
                return true
            }
        }
        return false
    }
    
    /// 해당 텍스트가 종성(받침)에 해당하는지를 확인한다.
    /// - Parameter char: 종성(받침) 여부를 확인할 Character
    /// - Returns: 종성(받침)인 경우 true, 그 외의 경우 false
    func isJong(char:Character) -> Bool {
        for i in 0 ..< jong.count {
            if jong[i] == char {
                return true
            }
        }
        return false
    }
    
    
    /// 초성, 중성, 종성 글자를 입력받아 완성된 한글로 변형하여 반환한다
    /// - Parameters:
    ///   - c1: 초성
    ///   - c2: 중성(모음)
    ///   - c3: 종성(받침)
    /// - Returns: 완성된 한글 텍스트를 반환한다.  실패한 경우 nil을 반환.
    func combine(c1:Character,c2:Character,c3:Character) -> Character? {
        var cho_i = 0
        var jung_i = 0
        var jong_i = 0
        
        for i in 0 ..< cho.count {
            if cho[i] == c1 {
                cho_i = i
                break
            }
        }
        
        for i in 0 ..< jung.count {
            if jung[i] == c2 {
                jung_i = i
                break
            }
        }
        
        for i in 0 ..< jong.count {
            if jong[i] == c3 {
                jong_i = i
                break
            }
        }
        
        let uniValue:Int = (cho_i * 21 * 28) + (jung_i * 28) + (jong_i) + 0xAC00
        if let uni = Unicode.Scalar(uniValue) {
            return Character(uni)
        }
        
        return nil
    }
}
