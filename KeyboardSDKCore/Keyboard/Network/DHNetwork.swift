//
//  DHApi.swift
//  DHCommonUtil
//
//  Created by DHLee on 2021/04/27.
//

import Foundation


public enum DHApiRequestType: String {
    case GET, POST
}

class DHApiConstants {
    
}


public protocol DHNetwork {
    
//    var customHost: String { get }
    
    var method: DHApiRequestType { get }
    var path: String { get }
    var parameters: [String : Any] { get }
    
    var isBodyData: Bool { get }
    
    var dataEncoding:String.Encoding { get }
}



public extension DHNetwork {
    
    var dataEncoding:String.Encoding {
        return .utf8
    }
    
    func request(with baseURL: URL) -> URLRequest {
        
        
        guard var components = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false) else {
            fatalError("Unable to create URL components")
        }

        if !isBodyData {
            components.queryItems = parameters.map {
                URLQueryItem(name: $0, value: $1 as? String ?? "")
            }
        }
        
        guard let url = components.url else {
            fatalError("Could not get url")
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.timeoutInterval = 15.0
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        if isBodyData {
            let jsonBody = parameters.jsonString
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonBody.data(using: .utf8)
        }
        
        
        return request
    }
}


