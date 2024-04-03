//
//  ENKeyboardThemeListModel.swift
//  KeyboardSDKCore
//
//  Created by cashwalkKeyboard on 2021/05/17.
//

import Foundation



public struct ENKeyboardThemeListModel: Codable, DHCodable {
    
    //성공시 포함
    public var data: [ENKeyboardThemeModel]?
    public var category: [ENKeyboardThemeCategoryModel]?
    
  
    private enum CodingKeys: String, CodingKey {
        case data = "data"
        case category = "category"

    }
    
}
