//
//  ENFrequentEmojiProvider.swift
//  KeyboardSDKCore
//
//  Created by cashwalkKeyboard on 2021/06/10.
//

import Foundation

/**
 This protocol can be implemented by classes that can return
 a list of frequently used emojis.
 
 When implementing this protocol, you should register when a
 keyboard uses an emoji, then return a frequent list that is
 based on the user's history.
*/
public protocol ENFrequentEmojiProvider: ENEmojiProvider, AnyObject {
    
    func registerEmoji(_ emoji: ENEmoji)
}
