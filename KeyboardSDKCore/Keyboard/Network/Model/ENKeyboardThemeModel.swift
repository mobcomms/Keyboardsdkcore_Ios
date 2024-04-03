//
//  ENKeyboardThemeModel.swift
//  KeyboardSDKCore
//
//  Created by cashwalkKeyboard on 2021/05/17.
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
    public var ispopular: String?


    public var isnew: String?
    public var isOwn:Bool?
    public var isNew:Bool {
        get {
            return isnew?.uppercased() == "Y"
        }
        
        set {
            isnew = newValue ? "Y" : "N"
        }
    }
    
    
    
    
    
    private enum CodingKeys: String, CodingKey {
        case idx = "theme_seq"
        case cat = "cat"
        case image = "image"
        case name = "name"
        case zip_file_name = "zip_file_name"
        case unzip_file_name = "unzip_file_name"
        case common_down_path = "common_down_path"
        case custom_down_path = "custom_down_path"
        case down_cnt = "down_cnt"
        case isnew = "theme_new_YN"
        case ispopular = "theme_popular_YN"
        case isOwn = "isOwn"
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
        ret.idx = "118"
        ret.cat = "09,25"
        ret.image = "https://cashwalk-api.commsad.com/img/theme/thumb/2/theme_118.png"
        ret.name = "default"
        ret.zip_file_name = "theme_118.zip"
        ret.unzip_file_name = "theme_118"
        ret.common_down_path = "https://cashwalk-api.commsad.com/img/theme/common/2/common_theme_118.zip"
        ret.custom_down_path = "https://cashwalk-api.commsad.com/img/theme/custom/2/custom_theme_118.zip"
        ret.down_cnt = "0"
        ret.isNew = false
        ret.ispopular = "N"
        ret.isOwn = true
        
        return ret
    }
    
    
    public func themeFileInfo() -> ENKeyboardThemeFileInfo {
        return ENKeyboardThemeFileInfo.init(name: name ?? "",
                                            keyboardUrl: common_down_path ?? "",
                                            customUrl: custom_down_path ?? "")
    }
    
}
