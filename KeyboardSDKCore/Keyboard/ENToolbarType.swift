//
//  ENToolbarType.swift
//  KeyboardSDKCore
//
//  Created by ximAir on 2023/09/06.
//

/// 툴바 아이템의 타입
///  추가나 삭제 시 꼭 수정 내용 적어주기
public enum ENToolbarType: Int {
    case keyboardEmoji      = 31 //  이모지
    case keyboardApp        = 32 //  앱
    case keyboardPPZone     = 33 //  PP존
    case keyboardCoupang    = 34 //  쿠팡
    case keyboardPointList  = 35 //  적립 내역
    case keyboardSetting    = 36 //  설정
    case keyboardCashDeal   = 37 //  캐시딜
}
