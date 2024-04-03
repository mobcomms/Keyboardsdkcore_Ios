//
//  ENKeyboardThemeModel.swift
//  KeyboardSDKCore
//
//  Created by enlipleIOS1 on 2021/05/17.
//

import Foundation

public class ENKeyboardThemeModel: Codable, DHCodable {
    
    public var idx: String?
    public var cat: String?
    public var image: String?
    public var name: String?
    public var zip_file_name: String?
    public var unzip_file_name: String?
    public var common_down_path: String?
    public var custom_down_path: String?
    public var down_cnt: String?
    public var down_path: String?
    public var apng_down_path: String?
    
    var theme_price: String?
    var ishave: String?
    var isnew: String?
    var isbuy: String?
    var ispay: String?
    
    public var isOwn:Bool {
        get {
            return ishave?.uppercased() == "Y"
        }
        
        set {
            ishave = newValue ? "Y" : "N"
        }
    }
    
    public var isNew:Bool {
        get {
            return isnew?.uppercased() == "Y"
        }
        
        set {
            isnew = newValue ? "Y" : "N"
        }
    }
    
    
    public var isBuy:Bool {
        get {
            return isbuy?.uppercased() == "Y"
        }
        
        set {
            isbuy = newValue ? "Y" : "N"
        }
    }
    
    
    public var price:Int {
        get {
            return Int.init(theme_price ?? "0") ?? 0
        }
        set {
            theme_price = "\(newValue)"
        }
    }
   
    
    public var isPay:Bool {
        get {
            return ispay?.uppercased() == "Y"
        }
        
        set {
            ispay = newValue ? "Y" : "N"
        }
    }
    
    
    public var isLive: Bool {
        get {
            return !(apng_down_path?.isEmpty ?? true)
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case idx = "theme_idx"
        case cat = "cat"
        case image = "image"
        case name = "name"
        case zip_file_name = "zip_file_name"
        case unzip_file_name = "unzip_file_name"
        case common_down_path = "common_down_path"
        case custom_down_path = "custom_down_path"
        case down_cnt = "down_cnt"
        case down_path = "down_path"
        case ishave = "ishave"
        case isnew = "isnew"
        case isbuy = "isbuy"
        case theme_price = "theme_price"
        case ispay = "ispay"
        case apng_down_path = "apng_down_path"
    }
    
    
    public static func parsing(json: String) -> ENKeyboardThemeModel? {
        if let data = json.data(using: .utf8) {
            do {
                let genericModel = try JSONDecoder().decode(ENKeyboardThemeModel.self, from: data)
                return genericModel
            } catch {
            }
        }
        
        return nil
    }
    
    static func defaultTheme() -> ENKeyboardThemeModel {
        let ret = ENKeyboardThemeModel.init()
        ret.cat = "0"
        ret.image = "https://okcashbag.cashkeyboard.co.kr/images/theme/2/thumb/theme_118.png"
        ret.name = "default"
        ret.zip_file_name = "theme_118.zip"
        ret.unzip_file_name = "theme_118"
        ret.common_down_path = "https://okcashbag.cashkeyboard.co.kr/images/theme/common/2/common_theme_118.zip"
        ret.custom_down_path = "https://okcashbag.cashkeyboard.co.kr/images/theme/OCB/2/custom_theme_118.zip"
        ret.down_cnt = "0"
        ret.theme_price = "0"
        ret.apng_down_path = ""
        
        return ret
    }
    
    
    public func themeFileInfo() -> ENKeyboardThemeFileInfo {
        return ENKeyboardThemeFileInfo.init(name: name ?? "",
                                            keyboardUrl: common_down_path ?? "",
                                            customUrl: custom_down_path ?? "")
    }
    
}
