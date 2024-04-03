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


public extension DHApi {
    
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
