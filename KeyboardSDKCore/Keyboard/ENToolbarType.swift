//
//  ENToolbarType.swift
//  KeyboardSDKCore
//
//  Created by ximAir on 2023/09/06.
//

/// 툴바 아이템의 타입
///  추가나 삭제 시 꼭 수정 내용 적어주기
public enum ENToolbarType: Int {
    case mobicomz       = 1  // 모비컴즈
    case emoji          = 2  // 이모지
    case emoticon       = 3  // 이모티콘
    case userMemo       = 4  // 자주쓰는 메모
    case clipboard      = 5  // 클립보드
    case coupang        = 6  // 쿠팡 바로가기
    case offerwall      = 7  // 오퍼월
    case dutchPay       = 8  // 더치페이
    case hotIssue       = 9  // 핫이슈
    case cursorLeft     = 10 // 커서이동/좌
    case cursorRight    = 11 // 커서이동/우
    case setting        = 12 // 설정으로 이동
    
    case hanaEmoji      = 31 // 하나머니 이모지
    case hanaApp        = 32 // 하나머니 앱
    case hanaPPZone     = 33 // 하나머니 PP존
    case hanaCoupang    = 34 // 하나머니 쿠팡
    case hanaPointList  = 35 // 하나머니 적립 내역
    case hanaSetting    = 36 // 하나머니 설정
}
