//
//  ENSettingManager.swift
//  KeyboardSDKCore
//
//  Created by enlipleIOS1 on 2021/05/20.
//

import Foundation
import AppTrackingTransparency
import AdSupport


/// 키보드 관련 설정값을 관리할 manager 객체
public class ENSettingManager {
    
    
    /// 공유 객체
    public static let shared:ENSettingManager = ENSettingManager()
    
    /// 사용자가 앱을 처음 사용하는것인지 값을 가져온다.
    ///  - true 면 처음 사용
    ///  - false 면 처음 사용이 아님
    public var isFirstUser: Bool {
        get {
            return UserDefaults.enKeyboardGroupStandard?.getIsFirstUser() ?? true
        }
        
        set {
            UserDefaults.enKeyboardGroupStandard?.setIsFirstUser(isFirst: newValue)
        }
    }
    
    /// 현재 사용중인 theme 객체
    public var useTheme:ENKeyboardThemeModel {
        get {
            return ENKeyboardThemeManager.shared.getCurrentTheme()
        }
        
        set {
            ENKeyboardThemeManager.shared.saveSelectedThemeInfo(theme: newValue)
        }
    }
    
    
    /// 키보드 자판 터치시 프리뷰를 화면에 표시할지 여부
    public var isKeyboardButtonValuePreviewShow: Bool {
        get {
            return UserDefaults.enKeyboardGroupStandard?.useKeyboardButtonValuePreview() ?? false
        }
        
        set {
            UserDefaults.enKeyboardGroupStandard?.setUseKeyboardButtonValuePreview(show: newValue)
        }
    }
    
    
    /// 키보드 자판 터치시 햅틱 반응 사용여부
    public var useHaptic: Bool {
        get {
            return UserDefaults.enKeyboardGroupStandard?.useHaptic() ?? false
        }
        
        set {
            UserDefaults.enKeyboardGroupStandard?.setUseHaptic(use: newValue)
        }
    }
    /// 진동 강도 가져오기
    public var hapticPower: Int {
        get {
            return UserDefaults.enKeyboardGroupStandard?.getHapticPower() ?? 0
        }
        
        set {
            UserDefaults.enKeyboardGroupStandard?.setHapticPower(power: newValue)
        }
    }
    /// 자주쓰는 메모 가져오기
    public var userMemo: [String] {
        get {
            return UserDefaults.enKeyboardGroupStandard?.getUserMemo() ?? []
        }
        
        set {
            UserDefaults.enKeyboardGroupStandard?.setUserMemo(memo: newValue)
        }
    }
    /// 툴바 스타일 가져오기
    public var toolbarStyle: ENToolbarStyle {
        get {
            return UserDefaults.enKeyboardGroupStandard?.getToolbarStyle() ?? .scroll
        }
        
        set {
            UserDefaults.enKeyboardGroupStandard?.setToolbarStyle(toolbarStyle: newValue)
        }
    }
    /// 툴바 아이템 array 가져오기
    public var toolbarItems: [ENToolbarItem] {
        get {
            return UserDefaults.enKeyboardGroupStandard?.getToolbar() ?? []
        }
        
        set {
            UserDefaults.enKeyboardGroupStandard?.setToolbar(toolbarArray: newValue)
        }
    }
    /// 타이핑 수 가져오기
    public var pressKeyboardCount: Int {
        get {
            return UserDefaults.enKeyboardGroupStandard?.getPressKeyboardCount() ?? 0
        }
        
        set {
            UserDefaults.enKeyboardGroupStandard?.setPressKeyboardCount(pressCount: newValue)
        }
    }
    /// 타이핑을 저장한 날짜 가져오기
    public var pressKeyboardCountDate: String {
        get {
            return UserDefaults.enKeyboardGroupStandard?.getPressKeyboardCountDate() ?? DHUtils.getNowDateToString()
        }
        
        set {
            UserDefaults.enKeyboardGroupStandard?.setPressKeyboardCountDate(insertDate: newValue)
        }
    }
    /// 뉴스 팝업 유무 가져오기
    public var useNewsAd: Bool {
        get {
            return UserDefaults.enKeyboardGroupStandard?.getUseNewsAd() ?? false
        }
        
        set {
            UserDefaults.enKeyboardGroupStandard?.setUseNewsAd(isUsed: newValue)
        }
    }
    /// 광고 팝업 유무 가져오기
    public var useAd: Bool {
        get {
            return UserDefaults.enKeyboardGroupStandard?.getUseAd() ?? false
        }
        
        set {
            UserDefaults.enKeyboardGroupStandard?.setUseAd(isUsed: newValue)
        }
    }
    
    /// 키보드 자판 터치시 효과음 사용여부
    public var useSound: Bool {
        get {
            return UserDefaults.enKeyboardGroupStandard?.useSound() ?? false
        }
        
        set {
            UserDefaults.enKeyboardGroupStandard?.setUseSound(use: newValue)
        }
    }
    
    /// 키보드 자판 터치시 재생되는 사운드 아이디
    public var soundID: Int {
        get {
            return UserDefaults.enKeyboardGroupStandard?.getSoundID() ?? 0
        }
        
        set {
            UserDefaults.enKeyboardGroupStandard?.setUseSoundId(newValue)
        }
    }
    
    /// 키보드 자판 높이 비율
    public var keyboardHeightRate: Float {
        get {
            return UserDefaults.enKeyboardGroupStandard?.getKeyboardHeightRate() ?? 20.0
        }
        
        set {
            UserDefaults.enKeyboardGroupStandard?.setKeyboardHeightRate(newValue)
        }
    }
    
    public var keyboardShowCount: Int {
        get {
            return UserDefaults.enKeyboardGroupStandard?.getShowRealKeyboard() ?? 0
        }
        
        set {
            UserDefaults.enKeyboardGroupStandard?.setShowRealKeyboard(index: newValue)
        }
    }
    
    public func getKeyboardHeight(isLandcape:Bool) -> CGFloat {
        if isLandcape {
            return 190
        }
        else {
            return (308 * (CGFloat(100 + (keyboardHeightRate - 20)) * 0.01)) - 50
        }
    }

    public func getKeyboardCustomHeightForDutchPay() -> CGFloat {
        return 90
    }
    
    public func getKeyboardCustomHeight(isLandcape:Bool) -> CGFloat {
        if isLandcape {
            return 40
        }else{
            return 45
        }
    }

    public var isUsePhotoTheme: Bool {
        get {
            return UserDefaults.standard.isUsePhotoTheme()
        }
        set {
            UserDefaults.standard.setUsePhotoTheme(isUse: newValue)
        }
        
    }
    
    public var photoThemeInfo: ENKeyboardTheme {
        get {
            return UserDefaults.standard.loadPhotoThemeInfo()
        }
        set {
            UserDefaults.standard.savePhotoThemeInfo(theme: newValue)
        }
    }
    
    public var keyboardType: ENKeyboardType {
        get {
            return UserDefaults.standard.getKeyboardType()
            
        }
        
        set {
            UserDefaults.standard.setKeyboardType(newValue)
        }
    }
    
    /** 하나머니 관련 로직 */
    /// 광고 IDFA getter & setter
    public var userIdfa: String {
        get {
            var tempIdfa = ""

            if #available(iOS 14, *) {
                if ATTrackingManager.trackingAuthorizationStatus == .authorized {
                    tempIdfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
                }else {
                    tempIdfa = ""
                }
            }else {
                tempIdfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
            }

            if tempIdfa.isEmpty {
                tempIdfa = vendorID

            }
            self.userIdfa = tempIdfa
            return tempIdfa

        }
        
        set {
            UserDefaults.enKeyboardGroupStandard?.setIDFA(idfa: newValue)

        }
    }
    var vendorID : String {
        if let vendor = UIDevice.current.identifierForVendor {
            return "hana_\(vendor.uuidString)"
        }else{
            return ""
        }
    }
    /// PPZ Token getter & setter
    public var ppzToken: String {
        get {
            return UserDefaults.enKeyboardGroupStandard?.getPPZToken() ?? ""
        }
        
        set {
            UserDefaults.enKeyboardGroupStandard?.setPPZToken(token: newValue)
        }
    }
    
    /// 최초 키보드 사용 값  getter & setter
    public var isFistUsingKeyboard: Bool {
        get {
            return UserDefaults.enKeyboardGroupStandard?.getFirstUsingKeyboard() ?? false
        }
        
        set {
            UserDefaults.enKeyboardGroupStandard?.setFirstUsingKeyboard(isFlag: newValue)
        }
    }
    
    /// 하나머니 고객 ID getter & setter
    public var hanaCustomerID: String {
        get {
            return UserDefaults.enKeyboardGroupStandard?.getHanaCustomerID() ?? ""
        }
        
        set {
            UserDefaults.enKeyboardGroupStandard?.setHanaCustomerID(customerID: newValue)
        }
    }
    
    /// 하나머니 키보드 3회 사용 카운트 값
    /// - 초기값 0
    /// - 0 에서 시작 후 1, 2, 3 증가
    /// - 3 에서 api 호출 후 포인트 주고 성공 시 0 세팅
    public var usingKeyboardCnt: Int {
        get {
            return UserDefaults.enKeyboardGroupStandard?.getUsingKeyboardCnt() ?? 0
        }
        
        set {
            UserDefaults.enKeyboardGroupStandard?.setUsingKeyboardCnt(cnt: newValue)
        }
    }
    
    /// 하나머니 키보드 3회 카운트 체크 시 flag 값
    /// - 초기값 true
    /// - 카운트 값이 0 에서 flag 값 체크 함
    /// - 이 값이 true 이면 카운트 값을 증가 후 false 로 바꿈
    /// - 이 값이 false 이면 카운트 값을 증가 시키지 않음
    /// - 키보드가 viewWillDisappear 되면 true 로 무조건 변경
    public var usingKeyboardCntFlag: Bool {
        get {
            return UserDefaults.enKeyboardGroupStandard?.getUsingKeyboardCntFlag() ?? true
        }
        
        set {
            UserDefaults.enKeyboardGroupStandard?.setUsingKeyboardCntFlag(cntFlag: newValue)
        }
    }
    
    /// 하나머니 포인트 적립을 위한 미리 쌓아두는 포인트
    /// - 해당 포인트는 실제로 적립된 포인트가 아님.
    /// - 상단 툴바에 포인트가 몇 쌓였는지 표시 해줄 때 사용함.
    /// - 상단 툴바에 포인트를 클릭 시 실제 포인트 적립 할 때 사용 될 값.
    public var readyForHanaPoint: Int {
        get {
            return UserDefaults.enKeyboardGroupStandard?.getReadyForHanaPoint() ?? 0
        }
        
        set {
            UserDefaults.enKeyboardGroupStandard?.setReadyForHanaPoint(point: newValue)
        }
    }
    
    /// 하나머니 상단 툴바의 브랜드 url
    public var toolbarBrandUrl: String {
        get {
            return UserDefaults.enKeyboardGroupStandard?.getToolbarBrandUrl() ?? ""
        }
        
        set {
            UserDefaults.enKeyboardGroupStandard?.setToolbarBrandUrl(brandUrl: newValue)
        }
    }
    
    /// 하나머니 상단 툴바의 브랜드 이미지 url
    public var toolbarBrandImageUrl: String {
        get {
            return UserDefaults.enKeyboardGroupStandard?.getToolbarBrandImageUrl() ?? ""
        }
        
        set {
            UserDefaults.enKeyboardGroupStandard?.setToolbarBrandImageUrl(brandImageUrl: newValue)
        }
    }
    
    public var brandUtilDay: String {
        get {
            return UserDefaults.enKeyboardGroupStandard?.getBrandUtilDay() ?? ""
        }
        
        set {
            UserDefaults.enKeyboardGroupStandard?.setBrandUtilDay(day: newValue)
        }
    }
    /** 광고 배너 적립 메시지 */
    /// 화면으로 돌아왔을 떄 메시지가 있을경우  토스트를 띄워줌
    public var zoneToastMsg: String {
        get {
            return UserDefaults.enKeyboardGroupStandard?.getToastMsg() ?? ""
        }
        
        set {
            UserDefaults.enKeyboardGroupStandard?.setToastMsg(msg: newValue)
        }
    }
    /// 하나머니 API Server Type (true: 개발 | false: 상용)
    /// - 값이 true 면 개발 서버
    /// - 값이 false 면 상용 서버
    /// - Defulat 값은 false 상용 서버
    public var setDebug: Bool {
        get {
            return UserDefaults.enKeyboardGroupStandard?.getIsDebug() ?? false
        }
        
        set {
            UserDefaults.enKeyboardGroupStandard?.setIsDebug(isDebug: newValue)
        }
    }
}
