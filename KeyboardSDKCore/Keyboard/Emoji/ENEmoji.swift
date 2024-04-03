//
//  ENEmoji.swift
//  KeyboardSDKCore
//
//  Created by cashwalkKeyboard on 2021/06/10.
//

import Foundation

public struct ENEmoji: Equatable, Hashable {
    
    public init(_ char: String) {
        self.char = char
    }
   
    public let char: String
    
    public func emojiToHex() -> String {
        var name = ""
        
        for item in char.unicodeScalars {
            
            name += String(item.value, radix: 16, uppercase: false)
            
            if item != char.unicodeScalars.last {
                name += "-"
            }
        }
        
        name = name.replacingOccurrences(of: "-fe0f", with: "")
        name = name.replacingOccurrences(of: "200d", with: "")
        name = name.replacingOccurrences(of: "--", with: "-")
        
        return name
    }
    
    public func toImage() -> UIImage? {
        let name = emojiToHex()
        
        let image = UIImage.init(named: name, in: Bundle.frameworkBundle, compatibleWith: nil)
        return image
    }
}

public extension ENEmoji {
    
    /// 전체 이모지 리스트를 가져온다
    static var all: [ENEmoji] {
        ENEmojiCategory.all.flatMap { $0.emojis }
    }
    
    
    
    
}
