//
//  ENKoreanQwertyAutomata.swift
//  KeyboardSDKCore
//
//  Created by enlipleIOS1 on 2021/05/06.
//

import Foundation



/// Qwerty자판용 한글 오토마타.
public class ENKoreanQwertyAutomata: ENKoreanAutomata {
    
    public override func makeTextWith(inputed: String?) {
        
//        DHLogger.log("makeTextWith : \(inputed ?? "")")
        
        checkBeforeInputed(cursorChangeChecker)
        
//        DHLogger.log("init first")
        if let inputed = inputed {
            if !isHangle(inputed: Character(inputed)) {
                clearInputed()
                super.insertText(inputed)
                
                return
            }
            else {
                realInputedChars.append(Character(inputed))
            }
        }
        
        charsForMakeTexts.removeAll()
        charsForMakeTexts.append(contentsOf: realInputedChars)
        
        super.makeTextWith(inputed: inputed)
    }
}
