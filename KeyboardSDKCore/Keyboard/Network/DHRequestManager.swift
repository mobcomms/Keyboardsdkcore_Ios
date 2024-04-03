//
//  DHRequestManager.swift
//  DHCommonUtil
//
//  Created by DHLee on 2021/04/27.
//
import Foundation



/*
 실제 api요청들을 처리하는 곳..
 
 api요청 발생시 관련 정보들을 이곳에 queue의 형대로 추가후
 자체 로직에 따라 api요청들을 순차적으로 처리한다.
 
 */


open class DHRequestManager {
    
    public static let shared: DHRequestManager = DHRequestManager()
//    
//    
//    /// 서버로부터 테마 리스트를 받아온다.
//    /// - Parameters:
//    ///   - userId: 사용자 ID
//    ///   - partnerCode: 조회할 카테고리의 부모 카테고리 코드
//    ///   - category: 조회할 카테고리 코드
//    open func getThemeList(userId: String?, partnerCode: String, category: String?) {
//        
//        let request:DHNetwork = DHApi.themeList(userId: userId, partnerCode: partnerCode, category: category)
//        
//        DHApiClient.shared.fetch(with: request) { (result: Result<DHResBase, DHApiError>) in
//            switch result {
//            case .success(let retValue):
//                DHLogger.log("\(retValue.debugDescription)")
//                break
//                
//            case .failure(let error):
//                DHLogger.log("\(error.localizedDescription)")
//                break
//            }
//        }
//        
//    }
}
