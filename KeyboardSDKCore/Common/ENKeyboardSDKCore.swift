//
//  ENKeyboardSDKCore.swift
//  KeyboardSDKCore
//
//  Created by enlipleIOS1 on 2021/05/17.
//

import Foundation


/// KeyboardSDKCore 관리용 객체
public class ENKeyboardSDKCore {
    
    /// 싱글톤 패턴 구현
    public static let shared:ENKeyboardSDKCore = ENKeyboardSDKCore()
    
    /// 앱과 데이터 공유를 위한 group id
     var groupId: String = ""
    
    /// 앱 api key
    public var apiKey: String = "123"


    var lastGesture:UIGestureRecognizer?

    /// group 공유 폴더 path
    public var groupDirectoryPath: String? {
        get {
            return groupDirectoryURL?.path
        }
    }
    
    /// group 공유 폴더 URL
    public var groupDirectoryURL: URL? {
        get {
            if !groupId.isEmpty {
                return FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: groupId)
            }
            else {
                return nil
            }
        }
    }
    
    //    /// ENKeyboardSDKCore를 초기화 시킨다.
    //    /// - Parameters:
    //    ///   - apiKey: 발급받은 API키
    //    ///   - groupId: 프로젝트 설정에서 지정한 group id
    init() {
        var groupID: String = "group.com.hana.hanamembers"
                if let bundleID = Bundle.main.bundleIdentifier, bundleID.contains("ent") {
                    groupID = "group.com.hana.hanamembers.ent"
                }

        self.groupId = groupID
//        self.groupId = "group.enkeyboardsdk.sample"
        DHApi.HOST = "https://api.cashkeyboard.co.kr/API"
    }
    
    
    /// 키보드를 사용하는 것으로 활성화 시켰는지 여부를 확인한다.
    /// - Returns: 키보드를 활성화 시킨 경우 true, 그 외의 경우 false
    public func isKeyboardExtensionEnabled() -> Bool {
        return DHUtils.isKeyboardExtensionEnabled()
    }
}
