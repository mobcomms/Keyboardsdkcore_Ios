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
            case "31":
                return .keyboardEmoji
            case "32":
                return .keyboardApp
            case "33":
                return .keyboardPPZone
            case "34":
                return .keyboardCoupang
            case "35":
                return .keyboardPointList
            case "36":
                return .keyboardSetting
            case "37":
                return .keyboardCashDeal
            default:
                return .keyboardEmoji
            }
        }
        set {
            switch newValue {
                 
            case .keyboardEmoji:
                self.toolbarType = "31"
            case .keyboardApp:
                self.toolbarType = "32"
            case .keyboardPPZone:
                self.toolbarType = "33"
            case .keyboardCoupang:
                self.toolbarType = "34"
            case .keyboardPointList:
                self.toolbarType = "35"
            case .keyboardSetting:
                self.toolbarType = "36"
            case .keyboardCashDeal:
                self.toolbarType = "37"
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
