//
//  ENToolbarStruct.swift
//  KeyboardSDKCore
//
//  Created by ximAir on 2023/09/06.
//

public class ENToolbarItem: Codable {
    public var toolbarType: String
    public var displayName: String
    public var imgName: String
    public var isUsed: String?
    
    init(toolbarType: String, displayName: String, imgName: String) {
        self.toolbarType = toolbarType
        self.displayName = displayName
        self.imgName = imgName
    }
    
    init(toolbarType: String, displayName: String, imgName: String, isUsed: String? = "N") {
        self.toolbarType = toolbarType
        self.displayName = displayName
        self.imgName = imgName
        self.isUsed = isUsed
    }
    
    private enum CodingKeys: String, CodingKey {
        case toolbarType = "toolbarType"
        case displayName = "displayName"
        case imgName = "imgName"
        case isUsed = "isUsed"
    }
    
    public var toolType: ENToolbarType {
        get {
            switch self.toolbarType {
            case "1":
                return .mobicomz
            case "2":
                return .emoji
            case "3":
                return .emoticon
            case "4":
                return .userMemo
            case "5":
                return .clipboard
            case "6":
                return .coupang
            case "7":
                return .offerwall
            case "8":
                return .dutchPay
            case "9":
                return .hotIssue
            case "10":
                return .cursorLeft
            case "11":
                return .cursorRight
            case "12":
                return .setting
                
            case "31":
                return .hanaEmoji
            case "32":
                return .hanaApp
            case "33":
                return .hanaPPZone
            case "34":
                return .hanaCoupang
            case "35":
                return .hanaPointList
            case "36":
                return .hanaSetting
            default:
                return .mobicomz
            }
        }
        set {
            switch newValue {
            case .mobicomz:
                self.toolbarType = "1"
            case .emoji:
                self.toolbarType = "2"
            case .emoticon:
                self.toolbarType = "3"
            case .userMemo:
                self.toolbarType = "4"
            case .clipboard:
                self.toolbarType = "5"
            case .coupang:
                self.toolbarType = "6"
            case .offerwall:
                self.toolbarType = "7"
            case .dutchPay:
                self.toolbarType = "8"
            case .hotIssue:
                self.toolbarType = "9"
            case .cursorLeft:
                self.toolbarType = "10"
            case .cursorRight:
                self.toolbarType = "11"
            case .setting:
                self.toolbarType = "12"
                
            case .hanaEmoji:
                self.toolbarType = "31"
            case .hanaApp:
                self.toolbarType = "32"
            case .hanaPPZone:
                self.toolbarType = "33"
            case .hanaCoupang:
                self.toolbarType = "34"
            case .hanaPointList:
                self.toolbarType = "35"
            case .hanaSetting:
                self.toolbarType = "36"
            }
        }
    }
    
    public var isUse: Bool {
        get {
            return self.isUsed == "Y" ? true : false
        }
        set {
            self.isUsed = newValue == true ? "Y" : "N"
        }
    }
    
    public static func parsing(json: String) -> ENToolbarItem? {
        if let data = json.data(using: .utf8) {
            do {
                let genericModel = try JSONDecoder().decode(ENToolbarItem.self, from: data)
                return genericModel
            } catch {
                
            }
        }
        
        return nil
    }
}
