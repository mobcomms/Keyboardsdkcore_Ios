//
//  ENKeyboardTheme.swift
//  KeyboardSDKCore
//
//  Created by enlipleIOS1 on 2021/05/10.
//

import Foundation
import UIKit





/**
 키보드 테마 메인.
 해당 객체 아래에 테마와 관련된 모든 정보에 접근 가능하다.
 */
public class ENKeyboardTheme {
    
    public var isPhotoTheme:Bool = false
    public var photoThemeBackgroundImageURL:String? = nil
    public var imageScale:CGFloat = 1.0
    public var imageOffsetX:CGFloat = 0.0
    public var imageOffsetY:CGFloat = 0.0
    public var imageUseWidth:CGFloat = 267.0
    public var imageUseHeight:CGFloat = 157.0
    public var imageAlpha:CGFloat = 0.0
    
    
    public var backgroundImage:UIImage?
    
    public var keyNormalBackgroundImage:UIImage?
    public var keyPressedBackgroundImage:UIImage?
    public var specialKeyNormalBackgroundImage:UIImage?
    public var specialKeyPressedBackgroundImage:UIImage?
    
    public var keyShiftNormalImage:UIImage?
    public var keyShiftPressedImage:UIImage?
    public var keyCapslockImage:UIImage?
    public var keySpaceImage:UIImage?
    public var keySpecialImage:UIImage?
    public var keyEnterImage:UIImage?
    public var keyDeleteImage:UIImage?
    public var keyEmojiIcon:UIImage?
    
    
    public var keyGlobalImage:UIImage?
    
    public var previewBackgroundImage:UIImage?
    
    /* 키보드 테마 색상정보 */
    public var themeColors: ENThemeColors = ENThemeColors.init()
    
    public init() {
    }
    
    
    
    /// 포토 테마 데이터를 JSON으로 변경한다.
    /// - Returns: json 데이터로 변경된 포토테마,  포토테마가 아닌경우 nil값이 반환된다.
    public func convertPhotoThemeToJsonString() -> String? {
        let colors = themeColors.toDictionary()
        
        var dict = Dictionary<String, Any>()
        dict["photoThemeBackgroundImageURL"] = photoThemeBackgroundImageURL
        dict["imageScale"] = imageScale
        dict["imageOffsetX"] = imageOffsetX
        dict["imageOffsetY"] = imageOffsetY
        dict["imageUseWidth"] = imageUseWidth
        dict["imageUseHeight"] = imageUseHeight
        dict["imageAlpha"] = imageAlpha
        
        dict["themeColors"] = colors
        
        return dict.jsonString
    }
    
    
    public func parsePhotoThemeFrom(json:String) {
        let dict = json.dictionary
        
        self.photoThemeBackgroundImageURL = dict["photoThemeBackgroundImageURL"] as? String ?? ""
        self.imageScale = dict["imageScale"] as? CGFloat ?? 1.0
        self.imageOffsetX = dict["imageOffsetX"] as? CGFloat ?? 0.0
        self.imageOffsetY = dict["imageOffsetY"] as? CGFloat ?? 0.0
        self.imageUseWidth = dict["imageUseWidth"] as? CGFloat ?? 267.0
        self.imageUseHeight = dict["imageUseHeight"] as? CGFloat ?? 157.0
        self.imageAlpha = dict["imageAlpha"] as? CGFloat ?? 157.0
        
        self.themeColors = ENThemeColors.init(json: dict["themeColors"] as? Dictionary<String, Any>, with: nil)
    }
}


extension ENKeyboardTheme {
    
    public func clear() {
        backgroundImage = nil
        
        keyNormalBackgroundImage = nil
        keyPressedBackgroundImage = nil
        specialKeyNormalBackgroundImage = nil
        specialKeyPressedBackgroundImage = nil
        
        keyShiftNormalImage = nil
        keyShiftPressedImage = nil
        keyCapslockImage = nil
        keySpaceImage = nil
        keySpecialImage = nil
        keyEnterImage = nil
        keyDeleteImage = nil
        keyEmojiIcon = nil
        
        keyGlobalImage = nil
        
        previewBackgroundImage = nil
    }
    
    public func loadPhotoThemeIcons() {
        var shiftNormalImage = UIImage.init(named: "paikbd_btn_keyboard_shift", in: Bundle.frameworkBundle, compatibleWith: nil)
        var shiftPressedImage = UIImage.init(named: "paikbd_btn_keyboard_shift_1", in: Bundle.frameworkBundle, compatibleWith: nil)
        var capslockImage = UIImage.init(named: "paikbd_btn_keyboard_shift_2", in: Bundle.frameworkBundle, compatibleWith: nil)
        var spaceImage = UIImage.init(named: "paikbd_btn_keyboard_space", in: Bundle.frameworkBundle, compatibleWith: nil)
        var specialImage = UIImage.init(named: "paikbd_btn_keyboard_sign", in: Bundle.frameworkBundle, compatibleWith: nil)
        var enterImage = UIImage.init(named: "paikbd_btn_keyboard_enter", in: Bundle.frameworkBundle, compatibleWith: nil)
        var deleteImage = UIImage.init(named: "paikbd_btn_keyboard_delete", in: Bundle.frameworkBundle, compatibleWith: nil)
        var globalImage = UIImage.init(named: "paikbd_btn_keyboard_text", in: Bundle.frameworkBundle, compatibleWith: nil)
        var previewImage = UIImage.init(named: "aikbd_btn_keyboard_preview", in: Bundle.frameworkBundle, compatibleWith: nil)
        var emojiIcon = UIImage.init(named: "aikbd_btn_keyboard_icon", in: Bundle.frameworkBundle, compatibleWith: nil)
        
        
        self.keyShiftNormalImage = shiftNormalImage
        self.keyShiftPressedImage = shiftPressedImage
        self.keyCapslockImage = capslockImage
        self.keySpaceImage = spaceImage
        self.keySpecialImage = specialImage
        self.keyEnterImage = enterImage
        self.keyDeleteImage = deleteImage
        self.keyGlobalImage = globalImage
        self.previewBackgroundImage = previewImage
        self.keyEmojiIcon = emojiIcon
        
        shiftNormalImage = nil
        shiftPressedImage = nil
        capslockImage = nil
        spaceImage = nil
        specialImage = nil
        enterImage = nil
        deleteImage = nil
        globalImage = nil
        previewImage = nil
        emojiIcon = nil
    }
}


