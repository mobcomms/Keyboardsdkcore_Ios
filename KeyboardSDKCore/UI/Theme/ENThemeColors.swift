//
//  ENThemeColors.swift
//  KeyboardSDKCore
//
//  Created by cashwalkKeyboard on 2021/05/12.
//

import Foundation
import UIKit




/// 테마에서 사용되는 색상값들을 저장하는 객체
public struct ENThemeColors {
    
    public var tab_off: UIColor = UIColor.init(hexString: "#FFF0F1F3")
    public var tab_on: UIColor = UIColor.init(hexString: "#FFF0F1F3")
    public var top_line: UIColor = UIColor.init(hexString: "#FFF0F1F3")
    public var key_text: UIColor = .white
    public var bot_line: UIColor = .white
    public var bot_tab_color: UIColor = .white
    public var fav_text: UIColor = .white
    public var sp_key_alpha: Int =  255
    public var nor_key_alpha: Int = 255
    public var nor_btn_color: UIColor = UIColor.init(white: 0.0, alpha: 0.9 * 0.7)
    public var sp_btn_color: UIColor = UIColor.init(white: 0.0, alpha: 0.9 * 0.7)
    public var bg_alpha: Int = 255
    
    public var specialKeyTextColor: UIColor = .white
    
    init() {
    }
    
    
    public init(json: Dictionary<String, Any>?, with image:UIImage?) {
        guard let json = json else {
            return
        }
        tab_off = UIColor.init(hexString: readHexString(json: json, key: "tab_off"))
        tab_on = UIColor.init(hexString: readHexString(json: json, key: "tab_on"))
        top_line = UIColor.init(hexString: readHexString(json: json, key: "top_line"))
        key_text = UIColor.init(hexString: readHexString(json: json, key: "key_text"))
        bot_line = UIColor.init(hexString: readHexString(json: json, key: "bot_line"))
        bot_tab_color = UIColor.init(hexString: readHexString(json: json, key: "bot_tab_color"))
        fav_text = UIColor.init(hexString: readHexString(json: json, key: "fav_text"))
        sp_key_alpha = (json["sp_key_alpha"] as? Int) ?? 0
        nor_key_alpha = (json["nor_key_alpha"] as? Int) ?? 0
        nor_btn_color = UIColor.init(hexString: readHexString(json: json, key: "nor_btn_color"))
        sp_btn_color = UIColor.init(hexString: readHexString(json: json, key: "sp_btn_color"))
        bg_alpha = (json["bg_alpha"] as? Int) ?? 0
        specialKeyTextColor = key_text
        
        if json.keys.contains("specialKeyTextColor") {
            specialKeyTextColor = UIColor.init(hexString: readHexString(json: json, key: "specialKeyTextColor"))
        }
        
        if let image = image, let colors = image.getColors() {
            if colors.background != .clear {
                self.specialKeyTextColor = colors.background
            }
            else if colors.primary != .clear {
                self.specialKeyTextColor = colors.primary
            }
            else {
                self.specialKeyTextColor = colors.secondary
            }
        }
        else {
            specialKeyTextColor = key_text
        }
        
        
        if specialKeyTextColor == .black || specialKeyTextColor == .white {
            specialKeyTextColor = key_text
        }
    }
    
    private func readHexString(json: Dictionary<String, Any>, key:String) -> String {
        return (json[key] as? String) ?? "#00FFFFFF"
    }
    
    
    func toDictionary() -> Dictionary<String, Any> {
        
        var dict = Dictionary<String, Any>()
        dict["tab_off"] = tab_off.toHexString()
        dict["tab_on"] = tab_on.toHexString()
        dict["top_line"] = top_line.toHexString()
        dict["key_text"] = key_text.toHexString()
        dict["bot_line"] = bot_line.toHexString()
        dict["bot_tab_color"] = bot_tab_color.toHexString()
        dict["fav_text"] = fav_text.toHexString()
        dict["sp_key_alpha"] = sp_key_alpha
        dict["nor_key_alpha"] = nor_key_alpha
        dict["nor_btn_color"] = nor_btn_color.toHexString()
        dict["sp_btn_color"] = sp_btn_color.toHexString()
        dict["bg_alpha"] = bg_alpha
        dict["specialKeyTextColor"] = specialKeyTextColor.toHexString()
        
        return dict
    }
}
