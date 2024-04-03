//
//  ENEmojiKeyboardConfiguration.swift
//  KeyboardSDKCore
//
//  Created by cashwalkKeyboard on 2021/06/10.
//


import CoreGraphics
import Foundation
import SwiftUI

/**
 This struct can be used to configure an `EmojiKeyboard`.
 
 This struct has a few standard values, which you can access
 with the static `standard` properties.
 
 Note that the struct has both an `itemSize` and a `font`. A
 lazy grid can use the itemSize as a precalculated cell size
 and then apply the font to each emoji.
 */
public struct ENEmojiKeyboardConfiguration {
    
    public init(
        itemSize: CGFloat = 40,
        rows: Int = 5,
        horizontalSpacing: CGFloat = 10,
        verticalSpacing: CGFloat = 6) {
        self.itemSize = itemSize
        self.rows = rows
        self.horizontalSpacing = horizontalSpacing
        self.verticalSpacing = verticalSpacing
    }
    
    public let itemSize: CGFloat
    public let rows: Int
    public let horizontalSpacing: CGFloat
    public let verticalSpacing: CGFloat
    
    var totalHeight: CGFloat { CGFloat(rows) * itemSize }
    
    public static let standardLargePadLandscape = ENEmojiKeyboardConfiguration(rows: 8)
    public static let standardLargePadPortrait = ENEmojiKeyboardConfiguration(rows: 5)
    public static let standardPadLandscape = ENEmojiKeyboardConfiguration(rows: 5)
    public static let standardPadPortrait = ENEmojiKeyboardConfiguration(rows: 3)
    public static let standardPhoneLandscape = ENEmojiKeyboardConfiguration(rows: 3)
    public static let standardPhonePortrait = ENEmojiKeyboardConfiguration(rows: 5)
}
