//
//  ENKeyboardThemeCategoryModel.swift
//  KeyboardSDKCore
//
//  Created by cashwalkKeyboard on 2021/05/17.
//

import Foundation


public struct ENKeyboardThemeCategoryModel: Codable, DHCodable {
    
    //성공시 포함
    public var code_id: String?
    public var code_val: String?
    
    private enum CodingKeys: String, CodingKey {
        case code_id = "code_id"
        case code_val = "code_val"
    }
}
