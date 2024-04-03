//
//  DHApi.swift
//  DHCommonUtil
//
//  Created by DHLee on 2021/04/27.
//

import Foundation




public struct DHApi {
    
    public static var HOST: String = ""
    
    public static var baseURL: URL {
        get {
            return URL(string: DHApi.HOST)!
        }
    }
    
}


/*
 host : https://api.cashkeyboard.co.kr/API/
 테마 목록
 - theme_cate.php
 param
         mParam.put("userid", userId); // 빈값도 상관 없음.
         mParam.put("scale_type", ""+scaleType); // "1" 입력하면 됩니다.
         mParam.put("partner_code", Common.WHOWHO_PARTNER_CODE);
         mParam.put("cate", category);
 Common.WHOWHO_PARTNER_CODE) = "00"
 category : default :: "00"
 오후 5:26
 썸네일
 김선균
 인기목록
 - theme_popular.php
 param
         mParam.put("userid", userId);
         mParam.put("scale_type", ""+scaleType);
         mParam.put("service_code", Common.SERVICE_CODE);
 -> theme_cate.php와 동일한 값
 
 
 */

public extension DHApi {
    
//    struct themeList: DHNetwork {
//        public var method: DHApiRequestType = .GET
//        public var path: String = "theme_cate.php"
//        public var parameters: [String:Any] = [String: Any]()
//        public var isBodyData: Bool = false
//        
//        public init(userId:String?, scaleType:String = "1", partnerCode:String, category:String?) {
//            parameters["userid"] = userId ?? ""
//            parameters["scale_type"] = scaleType
//            parameters["partner_code"] = partnerCode
//            parameters["cate"] = category ?? ""
//        }
//    }
    
    struct themePopularList: DHNetwork {
        public var customHost: String = ""
        
        public var method: DHApiRequestType = .GET
        public var path: String = "theme_popular.php"
        public var parameters: [String:Any] = [String: Any]()
        public var isBodyData: Bool = false
        
        public init(userId:String?, scaleType:String = "1", serviceCode:String = "01") {
            parameters["userid"] = userId ?? ""
            parameters["scale_type"] = scaleType
            parameters["service_code"] = serviceCode
        }
    }
}
