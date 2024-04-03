//
//  ENKeyboardThemeListModel.swift
//  KeyboardSDKCore
//
//  Created by enlipleIOS1 on 2021/05/17.
//

import Foundation



public struct ENKeyboardThemeListModel: Codable, DHCodable {
    
    //성공시 포함
    public var data: [ENKeyboardThemeModel]?
    
    private enum CodingKeys: String, CodingKey {
        case data = "data"
    }
    
}
