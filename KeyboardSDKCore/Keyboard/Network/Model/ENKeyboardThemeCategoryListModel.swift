//
//  ENKeyboardThemeCategoryListModel.swift
//  KeyboardSDKCore
//
//  Created by enlipleIOS1 on 2021/06/21.
//

import Foundation

public struct ENKeyboardThemeCategoryListModel: Codable, DHCodable {
    
    //성공시 포함
    public var category: ENKeyboardThemeCategorySubListModel?
    
    private enum CodingKeys: String, CodingKey {
        case category = "category"
    }
    
}


public struct ENKeyboardThemeCategorySubListModel: Codable, DHCodable {
    //성공시 포함
    public var word: [ENKeyboardThemeCategoryModel]?
    public var color: [ENKeyboardThemeCategoryModel]?
    
    private enum CodingKeys: String, CodingKey {
        case word = "word"
        case color = "color"
    }
    
}
