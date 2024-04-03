//
//  UserDefaults+ENKeyboard+Group.swift
//  KeyboardSDKCore
//
//  Created by enlipleIOS1 on 2021/05/17.
//

import Foundation

/// UserDefaults 객체에서 사용할 key 값들
enum ENKeyboardGroupUserDefaultsConstants: String {
    
    case keyForThemeInfo                    = "keyForThemeInfo"
    case keyForKeyboardButtonValuePreview   = "keyForKeyboardButtonValuePreview"
    case keyForUseHaptic                    = "keyForUseHaptic"
    case keyForUseSound                     = "keyForUseSound"
    case keyForSoundType                    = "keyForSoundType"
    case keyForKeyboardHeightRate           = "keyForKeyboardHeightRate"
    case keyForUsePhotoTheme                = "keyForUsePhotoTheme"
    case keyPhotoThemeInfo                  = "keyPhotoThemeInfo"
    case keyKeyboardType                    = "keyKeyboardType" // 이것도 지워야함
    case keyToolbarArray                    = "keyToolbarArray" // 지워야함
    case keyHapticPower                     = "keyHapticPower"
    case keyUserMemo                        = "keyUserMemo"
    case keyToolbarStyle                    = "keyToolbarStyle"
    case keyToolbarItemArray                = "keyToolbarItemArray"
    case keyUseNewsAd                       = "keyUseNewsAd"
    case keyUseAd                           = "keyUseAd"
    case keyPressKeyboardCount              = "keyPressKeyboardCount"
    case keyPressKeyboardCountDate          = "keyPressKeyboardCountDate"
    case keyShowRealKeyboard                = "keyShowRealKeyboard"
    case keyIsFirstUser                     = "keyIsFirstUser"
    case keyIDFA                            = "keyIDFA"
    case keyPPZToken                        = "keyPPZToken"
    case keyFirstUsingKeyboard              = "keyFirstUsingKeyboard"
    case keyHanaCustomerID                  = "keyHanaCustomerID"
    case keyUsingKeyboardCnt                = "keyUsingKeyboardCnt"
    case keyUsingKeyboardCntFlag            = "keyUsingKeyboardCntFlag"
    case keyReadyForHanaPoint               = "keyReadyForHanaPoint"
    case keyToolbarBrandUrl                 = "keyToolbarBrandUrl"
    case keyToolbarBrandImageUrl            = "keyToolbarBrandImageUrl"
    case keyBrandUtilDay                    = "keyBrandUtilDay"
    case keyAPIServerType                   = "keyAPIServerType"
    case keyZoneToastMsg                    = "keyZoneToastMsg"

    /// 키 값을 string value로 변경하여 반환한다.
    var value: String {
        return "ENKeyboardGroupUserDefaults_\(self.rawValue)"
    };
}




public extension UserDefaults {
    
    /// App <-> App Extension 간 공유할 데이터를 담을 UserDefaults 객체
    static var enKeyboardGroupStandard:UserDefaults? {
        get {
            let groupId = ENKeyboardSDKCore.shared.groupId
            
            return (groupId.isEmpty ? nil : UserDefaults.init(suiteName: groupId))
        }
    }
    
    
    /// ENKeyboardGroupUserDefaultsConstants를 키값으로 UserDefault에 값을 설정해 준다.
    /// - Parameters:
    ///   - value: 저장할 값
    ///   - key: ENKeyboardGroupUserDefaultsConstants 키 값
    private func setValue(_ value: Any?, key: ENKeyboardGroupUserDefaultsConstants) {
        UserDefaults.enKeyboardGroupStandard?.setValue(value, forKey: key.value)
        UserDefaults.enKeyboardGroupStandard?.synchronize()
    }
    
    
    /// ENKeyboardGroupUserDefaultsConstants를 키값으로 UserDefault에서 값을 가져온다.
    /// - Parameter key: ENKeyboardGroupUserDefaultsConstants 키 값
    /// - Returns: 해당 key값에 할당되어 있는 value
    private func value(forKey key: ENKeyboardGroupUserDefaultsConstants) -> Any? {
        return UserDefaults.enKeyboardGroupStandard?.value(forKey: key.value)
    }
    
    
    
    /// 포토 테마 사용여부를 가져온다
    /// - Returns: 포토테마를 사용하는 경우 true, 그 외의 경우 false
    func isUsePhotoTheme() -> Bool {
        return value(forKey: .keyForUsePhotoTheme) as? Bool ?? false
    }
    
    
    /// 포토 테마 사용 여부를 저장한다.
    /// - Parameter isUse: 포토 테마 사용 여부에 대한 boolean 값
    func setUsePhotoTheme(isUse:Bool) {
        setValue(isUse, key: .keyForUsePhotoTheme)
    }
    
    
    
    /// 포토 테마 정보를 저장한다
    /// - Parameter theme: 사용중인 포토테마 정보
    func savePhotoThemeInfo(theme:ENKeyboardTheme) {
        let photoJSON = theme.convertPhotoThemeToJsonString()
        setValue(photoJSON, key: .keyForThemeInfo)
    }
    
    
    /// 저장된 포토테마 정보를 가져온다.
    /// - Returns: 저장된 포토테마 정보
    func loadPhotoThemeInfo() -> ENKeyboardTheme {
        let photoJson = value(forKey: .keyForThemeInfo) as? String ?? ""
        
        let theme = ENKeyboardTheme.init()
        theme.parsePhotoThemeFrom(json: photoJson)
        
        return theme
    }
    
    
    
    
    /// 사용을 설정한 Theme에 대한 정보를 저장한다
    /// - Parameter theme: 선택된 Theme 정보를 가진 ENKeyboardThemeModel 객체
    func setSelectedThemeInfo(theme: ENKeyboardThemeModel) {
        let json = theme.json
        setValue(json, key: .keyForThemeInfo)
    }
    
    
    /// 사용을 설정한 Theme에 대한 정보를 가져온다
    /// - Returns: 저장된 ENKeyboardThemeModel 객체,  저장된 테마가 없거나 가져오는데 오류 발생시 nil을 반환한다.
    func getSelectedThemeInfo() -> ENKeyboardThemeModel? {
        if let json = value(forKey: .keyForThemeInfo) as? String {
            return ENKeyboardThemeModel.parsing(json: json)
        }
        
        return nil
    }
    
    
    /// 현재 누르고 있는 자판을 크게 보여주는 기능 설정 값을 저장한다.
    /// - Parameter show:프리뷰 기능을 사용하는 경우 true, 그 외의 경우 false를 설정한다.
    func setUseKeyboardButtonValuePreview(show: Bool) {
        setValue(show, key: .keyForKeyboardButtonValuePreview)
    }
    
    
    /// 현재 누르고 있는 자판을 크게 보여주는 기능의 설정 값을 가져온다.
    /// - Returns: 프리뷰 기능을 사용하는 경우 true, 그 외의 경우 false
    func useKeyboardButtonValuePreview() -> Bool {
        return ((value(forKey: .keyForKeyboardButtonValuePreview) as? Bool) ?? false)
    }
    
 
    
    /// 키보드 자판 터치시 진동을 사용 여부에 대한 값을 저장한다
    /// - Parameter use: 진동 기능을 사용하는 경우 ture, 그외의 경우 false
    func setUseHaptic(use:Bool) {
        setValue(use, key: .keyForUseHaptic)
    }
    
    /// 햅틱 강도를 세팅한다.
    func setHapticPower(power: Int) {
        setValue(power, key: .keyHapticPower)
    }
    
    /// 햅틱 강도를 가져온다.
    func getHapticPower() -> Int {
        return ((value(forKey: .keyHapticPower) as? Int) ?? 0)
    }
    /// 자주 사용하는 메모 데이터 세팅
    func setUserMemo(memo: [String]) {
        setValue(memo, key: .keyUserMemo)
    }
    /// 자주 사용하는 메모 가져옴
    func getUserMemo() -> [String] {
        return ((value(forKey: .keyUserMemo) as? [String]) ?? [])
    }
    /// 타이핑 세팅
    func setPressKeyboardCount(pressCount: Int) {
        setValue(pressCount, key: .keyPressKeyboardCount)
    }
    /// 타이핑 가져오기
    func getPressKeyboardCount() -> Int {
        return ((value(forKey: .keyPressKeyboardCount) as? Int) ?? 0)
    }
    /// 타이핑 세팅한 날짜 세팅
    func setPressKeyboardCountDate(insertDate: String) {
        setValue(insertDate, key: .keyPressKeyboardCountDate)
    }
    /// 타이핑 세팅한 날짜 가져오기
    func getPressKeyboardCountDate() -> String {
        return ((value(forKey: .keyPressKeyboardCountDate) as? String) ?? DHUtils.getNowDateToString())
    }
    /// 뉴스 팝업 쓸지 가져옴
    func getUseNewsAd() -> Bool {
        return (value(forKey: .keyUseNewsAd) as? Bool) ?? false
    }
    /// 뉴스 팝업 쓸지 세팅함
    func setUseNewsAd(isUsed: Bool) {
        setValue(isUsed, key: .keyUseNewsAd)
    }
    /// 광고 팝업 쓸지 가져옴
    func getUseAd() -> Bool {
        return (value(forKey: .keyUseAd) as? Bool) ?? false
    }
    /// 광고 팝업 쓸지 세팅함
    func setUseAd(isUsed: Bool) {
        setValue(isUsed, key: .keyUseAd)
    }
    
    /// 키보드 자판 터치시 진동 사용 여부에 대해 저장된 값을 가져온다.
    /// - Returns: 진동 기능을 사용하는 경우 ture, 그외의 경우 false
    func useHaptic() -> Bool {
        return ((value(forKey: .keyForUseHaptic) as? Bool) ?? false)
    }
    
    
    /// 키보드 자판 터치시 사운드 사용 여부에 대한 값을 저장한다
    /// - Parameter use: 사운드 기능을 사용하는 경우 ture, 그외의 경우 false
    func setUseSound(use:Bool) {
        setValue(use, key: .keyForUseSound)
    }
    
    
    /// 키보드 자판 터치시 사운드 사용 여부에 대해 저장된 값을 가져온다.
    /// - Returns: 사운드 기능을 사용하는 경우 ture, 그외의 경우 false
    func useSound() -> Bool {
        return ((value(forKey: .keyForUseSound) as? Bool) ?? false)
    }
    
    
    /// 키보드 자판 터치시 재생한 사운드 종류를 저장한다
    /// - Parameter soundId: 사운드 인덱스 값
    func setUseSoundId(_ soundId:Int) {
        setValue(soundId, key: .keyForSoundType)
    }
    
    
    /// 키보드 자판 터치시 재생할 사운드 종류에 대한 값을 가져온다
    /// - Returns: 사운드 인덱스 값.  기본값은 0이다.
    func getSoundID() -> Int {
        return ((value(forKey: .keyForSoundType) as? Int) ?? 0)
    }
    
    
    
    /// 키보드 높이에 대한 슬라이드 값을 저장한다.
    /// - Parameter rate: 키보드 높이 값 0 ~ 40까지의 값.  기본값은 20이다.
    func setKeyboardHeightRate(_ rate:Float = 20.0) {
        setValue(rate, key: .keyForKeyboardHeightRate)
    }
    
    
    /// 키보드 높이에 대한 슬라이드 값을 가져온다
    /// - Returns: 저장된 키보드 높이 값.  기본값은 20.0 이다
    func getKeyboardHeightRate() -> Float {
        return ((value(forKey: .keyForKeyboardHeightRate) as? Float) ?? 20.0)
    }
    
    /// 사용중인 키보드 타입을 저장한다.
    /// - Parameter type: 사용중인 키보드 타입값
    func setKeyboardType(_ type:ENKeyboardType) {
        setValue(type.rawValue, key: .keyKeyboardType)
    }
    
    /// 사용중인 키보드 타입을 가져온다.
    /// - Returns: 사용중인 키보드 타입. 기본값은 qwerty
    func getKeyboardType() -> ENKeyboardType {
        let value = (value(forKey: .keyKeyboardType) as? Int)
        return ENKeyboardType(rawValue: value ?? 0) ?? .qwerty
    }
    /// 툴바 스타일 세팅
    func setToolbarStyle(toolbarStyle: ENToolbarStyle) {
        setValue(toolbarStyle.rawValue, key: .keyToolbarStyle)
    }
    /// 툴바 스타일 가져오기
    func getToolbarStyle() -> ENToolbarStyle {
        let value = (value(forKey: .keyToolbarStyle) as? Int)
        return ENToolbarStyle(rawValue: value ?? 0) ?? .scroll
    }
    
    /// 키보드가 몇번 올라왔는지 세팅함
    func setShowRealKeyboard(index: Int) {
        setValue(index, key: .keyShowRealKeyboard)
    }
    /// 키보드가 몇번 올라왔는지 가져옴
    func getShowRealKeyboard() -> Int {
        return (value(forKey: .keyShowRealKeyboard) as? Int) ?? 0
    }
    
    /// 처음 사용인지 세팅
    ///  - false = 처음이 아님
    ///  - true = 처음임
    func setIsFirstUser(isFirst: Bool) {
        setValue(isFirst, key: .keyIsFirstUser)
    }
    
    /// 처음 사용인지 값 가져오기
    ///   - false = 처음이 아님
    ///   - true = 처음임
    func getIsFirstUser() -> Bool {
        return (value(forKey: .keyIsFirstUser) as? Bool) ?? true
    }
    
    /// 키보드 툴바의 표시 될 Bool 값
    /// - Parameters:
    ///  - toolbarArray: 키고 끌 툴바의 Int 값
    /// - [0, 1, 2, 3, 4, 5, 6] 7개가 고정 (추가로 늘릴 때마다 값을 하나 씩
    /// - 9개가 되면 0, 1, 2, 3, 4, 5, 6, 7, 8
    /// - 맨 앞 부터 설정, 이모지, 쿠팡광고, 클립보드, 북마크, 게임, 커스텀
    func setToolbarArray(toolbarArray: [Int]) {
        setValue(toolbarArray, key: .keyToolbarArray)
    }
    
    /// 키보드 툴바의 표시 될 값
    /// - Returns: 키고 끌 툴바의 Array 형태의 Int 값
    /// - [0, 1, 2, 3, 4, 5, 6] 7개가 고정 (추가로 늘릴 때마다 값을 하나 씩
    /// - 9개가 되면 0, 1, 2, 3, 4, 5, 6, 7, 8
    /// - 맨 앞 부터 설정, 이모지, 쿠팡광고, 클립보드, 북마크, 게임, 커스텀
    func getToolbarArray() -> [Int] {
        if let tempArray = value(forKey: .keyToolbarArray) {
            return (tempArray as? [Int]) ?? []
        } else {
            let toolbarArr: [Int] = [ENConstants.SETTING, ENConstants.EMOJI, ENConstants.AD, ENConstants.CLIP_BOARD, ENConstants.BOOK_MARK, ENConstants.GAME, ENConstants.ADD_TYPE]
            setToolbarArray(toolbarArray: toolbarArr)
            return (value(forKey: .keyToolbarArray) as? [Int]) ?? []
        }
    }
    /// 툴바 아이템 세팅
    func setToolbar(toolbarArray: [ENToolbarItem]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(toolbarArray) {
            setValue(encoded, key: .keyToolbarItemArray)
        }
    }
    /// 툴바 아이템 가져오기
    func getToolbar() -> [ENToolbarItem] {
        if let temp = value(forKey: .keyToolbarItemArray) as? Data {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([ENToolbarItem].self, from: temp) {
                return decoded
            }
        }
        return defaultToolbarItmes()
    }
    /// 디폴트로 설정함
    private func defaultToolbarItmes() -> [ENToolbarItem] {
        let toolbarArray: [ENToolbarItem] = [
            ENToolbarItem.init(toolbarType: "1", displayName: "모비컴즈", imgName: "cell_toolbar_mobicomz", isUsed: "N"),
            ENToolbarItem.init(toolbarType: "2", displayName: "이모지", imgName: "cell_toolbar_emoji", isUsed: "N"),
            ENToolbarItem.init(toolbarType: "3", displayName: "이모티콘", imgName: "cell_toolbar_emoticon", isUsed: "N"),
            ENToolbarItem.init(toolbarType: "4", displayName: "자주쓰는 메모", imgName: "cell_toolbar_memo", isUsed: "N"),
            ENToolbarItem.init(toolbarType: "5", displayName: "클립보드", imgName: "cell_toolbar_clipboard", isUsed: "N"),
            ENToolbarItem.init(toolbarType: "6", displayName: "쿠팡 바로가기", imgName: "cell_toolbar_coupang", isUsed: "N"),
            ENToolbarItem.init(toolbarType: "7", displayName: "오퍼월", imgName: "cell_toolbar_opewarl", isUsed: "N"),
            ENToolbarItem.init(toolbarType: "8", displayName: "더치페이", imgName: "cell_toolbar_pay", isUsed: "N"),
            ENToolbarItem.init(toolbarType: "9", displayName: "핫이슈", imgName: "cell_toolbar_hot", isUsed: "N"),
            ENToolbarItem.init(toolbarType: "10", displayName: "커서이동/좌", imgName: "cell_toolbar_left", isUsed: "N"),
            ENToolbarItem.init(toolbarType: "11", displayName: "커서이동/우", imgName: "cell_toolbar_right", isUsed: "N"),
            ENToolbarItem.init(toolbarType: "12", displayName: "설정", imgName: "cell_toolbar_setting", isUsed: "N"),
            
            ENToolbarItem.init(toolbarType: "31", displayName: "하나머니 이모지", imgName: "hana_toolbar_emoji", isUsed: "Y"),
            ENToolbarItem.init(toolbarType: "32", displayName: "하나머니 앱", imgName: "hana_toolbar_app", isUsed: "Y"),
            ENToolbarItem.init(toolbarType: "33", displayName: "하나머니 PP존", imgName: "hana_toolbar_ppzone", isUsed: "Y"),
            ENToolbarItem.init(toolbarType: "34", displayName: "하나머니 쿠팡", imgName: "hana_toolbar_coupang", isUsed: "Y"),
            ENToolbarItem.init(toolbarType: "35", displayName: "하나머니 적립 내역", imgName: "hana_toolbar_point_list", isUsed: "Y"),
            ENToolbarItem.init(toolbarType: "36", displayName: "하나머니 설정", imgName: "hana_toolbar_setting", isUsed: "Y"),
            
        ]
        setToolbar(toolbarArray: toolbarArray)
        return toolbarArray
    }
    
    
    /** 하나 머니 관련 로직 */
    /** 하나 머니 관련 로직 */
    /** 하나 머니 관련 로직 */
    /** 하나 머니 관련 로직 */
    /** 하나 머니 관련 로직 */
    
    /// 하나머니 API Server Type (true: 개발 | false: 상용)
    func setIsDebug(isDebug: Bool) {
        setValue(isDebug, key: .keyAPIServerType)
    }
    func getIsDebug() -> Bool {
        return ((value(forKey: .keyAPIServerType) as? Bool) ?? true)
    }
    
    /// 광고 IDFA 세팅
    func setIDFA(idfa: String) {
        setValue(idfa, key: .keyIDFA)
    }
    /// 광고 IDFA 가져오기
    func getIDFA() -> String {
        return ((value(forKey: .keyIDFA) as? String) ?? "nil")
    }
    /// PPZ Token 세팅
    func setPPZToken(token: String) {
        setValue(token, key: .keyPPZToken)
    }
    /// PPZ Token 가져오기
    func getPPZToken() -> String {
        return ((value(forKey: .keyPPZToken) as? String) ?? "")
    }
    
    /// 최초 등록 가져오기...
    func getFirstUsingKeyboard() -> Bool {
        return ((value(forKey: .keyFirstUsingKeyboard) as? Bool) ?? false)
    }
    /// 최초 등록 세팅...
    func setFirstUsingKeyboard(isFlag: Bool) {
        setValue(isFlag, key: .keyFirstUsingKeyboard)
    }
    
    /// 하나머니 고객 아이디 세팅
    func setHanaCustomerID(customerID: String) {
        setValue(customerID, key: .keyHanaCustomerID)
    }
    /// 하나머니 고객 아이디 가져오기
    func getHanaCustomerID() -> String {
        return ((value(forKey: .keyHanaCustomerID) as? String) ?? "")
    }
    ///  광고배너 토스트 메시지 가져오기
    func getToastMsg() -> String {
        return ((value(forKey: .keyZoneToastMsg) as? String) ?? "")
    }
    /// 하나머니 키보드 3회 썻는지 카운트 세팅 (시작값 0 으로 할거임! 그 뒤로 1 2 3 증가! 3에서 포인트 주고 0 만들기)
    func setUsingKeyboardCnt(cnt: Int) {
        setValue(cnt, key: .keyUsingKeyboardCnt)
    }
    /// 하나머니 키보드 3회 썻는지 카운트 가져오기 (시작값 0 으로 할거임! 그 뒤로 1 2 3 증가! 3에서 포인트 주고 0 만들기)
    func getUsingKeyboardCnt() -> Int {
        return ((value(forKey: .keyUsingKeyboardCnt) as? Int) ?? 0)
    }
    
    /// 하나머니 키보드 3회 카운팅 구분하기 위한 값 (0 -> 1로 증가 후 이 값을 바꿔서 더이상 증가 안하게 함! 단 키보드가 viewWillDisappear 되면 이 값을 다시 바꿈
    func setUsingKeyboardCntFlag(cntFlag: Bool) {
        setValue(cntFlag, key: .keyUsingKeyboardCntFlag)
    }
    /// 하나머니 키보드 3회 카운팅 구분하기 위한 값 (0 -> 1로 증가 후 이 값을 바꿔서 더이상 증가 안하게 함! 단 키보드가 viewWillDisappear 되면 이 값을 다시 바꿈
    func getUsingKeyboardCntFlag() -> Bool {
        return ((value(forKey: .keyUsingKeyboardCntFlag) as? Bool) ?? true)
    }
    
    /// 하나머니 포인트 쌓는 카운트 (이건 포인트가 실제 적립된게 아님!!!)
    func setReadyForHanaPoint(point: Int) {
        setValue(point, key: .keyReadyForHanaPoint)
    }
    /// 하나머니 포인트 쌓는 카운트 (이건 포인트가 실제 적립된게 아님!!!)
    func getReadyForHanaPoint() -> Int {
        return ((value(forKey: .keyReadyForHanaPoint) as? Int) ?? 0)
    }
    
    /// 상단 툴바의 쿠팡 및 브랜드 광고 url
    func setToolbarBrandUrl(brandUrl: String) {
        setValue(brandUrl, key: .keyToolbarBrandUrl)
    }
    /// 상단 툴바의 쿠팡 및 브랜드 광고 url
    func getToolbarBrandUrl() -> String {
        return ((value(forKey: .keyToolbarBrandUrl) as? String) ?? "")
    }
    
    /// 상단 툴바의 쿠팡 및 브랜드 광고 이미지 url
    func setToolbarBrandImageUrl(brandImageUrl: String) {
        setValue(brandImageUrl, key: .keyToolbarBrandImageUrl)
    }
    /// 상단 툴바의 쿠팡 및 브랜드 광고 이미지 url
    func getToolbarBrandImageUrl() -> String {
        return ((value(forKey: .keyToolbarBrandImageUrl) as? String) ?? "")
    }
    
    func setBrandUtilDay(day: String) {
        setValue(day, key: .keyBrandUtilDay)
    }
    func getBrandUtilDay() -> String {
        return ((value(forKey: .keyBrandUtilDay) as? String) ?? "")
    }
    ///  광고배너 토스트 메시지 저장
    func setToastMsg(msg:String) {
        setValue(msg, key: .keyZoneToastMsg)
    }
}
