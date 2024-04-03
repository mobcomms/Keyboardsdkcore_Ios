//
//  ENConstants.swift
//  KeyboardSDKCore
//
//  Created by cashwalkKeyboard on 2021/05/04.
//

import Foundation
import UIKit

public enum ENConstants {
	
    /*      Qwerty      */
	static let alphabetKeys = [
		["q", "w", "e", "r", "t", "y", "u", "i", "o", "p"],
		["a", "s", "d", "f", "g","h", "j", "k", "l"],
		["⇧", "z", "x", "c", "v", "b", "n", "m", "⌫"],
		["123", "🌐", "☺︎", "space", "⮐"]
	]
    
    static let hangleKeys = [
        ["ㅂ", "ㅈ", "ㄷ", "ㄱ", "ㅅ", "ㅛ", "ㅕ", "ㅑ", "ㅐ", "ㅔ"],
        ["ㅁ", "ㄴ", "ㅇ", "ㄹ", "ㅎ","ㅗ", "ㅓ", "ㅏ", "ㅣ"],
        ["⇧", "ㅋ", "ㅌ", "ㅊ", "ㅍ", "ㅠ", "ㅜ", "ㅡ", "⌫"],
        ["123", "🌐", "☺︎", "space", "⮐"]
    ]
    
    static let shiftedHangleKeys = [
        ["ㅃ", "ㅉ", "ㄸ", "ㄲ", "ㅆ", "ㅛ", "ㅕ", "ㅑ", "ㅒ", "ㅖ"],
        ["ㅁ", "ㄴ", "ㅇ", "ㄹ", "ㅎ","ㅗ", "ㅓ", "ㅏ", "ㅣ"],
        ["⇧", "ㅋ", "ㅌ", "ㅊ", "ㅍ", "ㅠ", "ㅜ", "ㅡ", "⌫"],
        ["123", "🌐", "☺︎", "space", "⮐"]
    ]
    
	static let numberKeys = [
		["1", "2", "3", "4", "5", "6", "7", "8", "9", "0",],
		["-", "/", ":", ";", "(", ")" , "$", "&", "@", "\""],
		["#+=",".", ",", "?", "!", "\'", "⌫"],
		["letter", "🌐", "☺︎", "space", "⮐"]
	]
	
	static let symbolKeys = [
		["[", "]", "{", "}", "#", "%", "^", "*", "+", "="],
		["_", "\\", "|", "~", "<", ">", "€", "£", "¥", "•"],
		["123",".", ",", "?", "!", "\'", "⌫"],
		["letter", "🌐", "☺︎", "space", "⮐"]
	]
    
    
    /*      10Key      */
    static let alphabet10Key = [
        ["#123", "ABC", "한글", "☺︎"],
        ["@#/&", "ghi", "pqrs", "→"],
        ["abc", "jkl", "tuv", ".,?!"],
        ["def", "mno", "wxyz", "⇧"],
        ["⌫", "⮐", "space"]
    ]
    
    static let hangle10Key = [
        ["#123", "ABC", "한글", "☺︎"],
        [String(ENConstants.keyIn), "ㄱㅋ", "ㅂㅍ", "→"],
        [String(ENConstants.keyChun), "ㄴㄹ", "ㅅㅎ", "ㅇㅁ"],
        [String(ENConstants.keyJi), "ㄷㅌ", "ㅈㅊ", ".,?!"],
        ["⌫", "⮐", "space"]
    ]
    
    
    
    static let number10Key = [
        ["#123", "ABC", "한글", "☺︎"],
        ["1", "4", "7", "→"],
        ["2", "5", "8", "0"],
        ["3", "6", "9", ".,?!"],
        ["⌫", "⮐", "space"]
    ]
    
    static let numberSub10Key = [
        ["", "", "", ""],
        ["(-)", "{*}", "[:]", "→"],
        ["￦$¥", "+×÷", "\"';", "~…*"],
        ["^%#", "<=>", "/\\|", ""],
        ["", "", ""]
    ]
    
    
    //    천(ㆍ), 지(ㅡ), 인(ㅣ)
    static let keyChun: Character = "﹒"
    static let keyJi: Character = "ㅡ"
    static let keyIn: Character = "|"
    static let keyDoubleChun: Character = "﹕"
    
    static let SETTING: Int = 0
    static let EMOJI: Int = 1
    static let AD: Int = 2
    static let CLIP_BOARD: Int = 3
    static let BOOK_MARK: Int = 4
    static let GAME: Int = 5
    static let ADD_TYPE: Int = 100
    
}


