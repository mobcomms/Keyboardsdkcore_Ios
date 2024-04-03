//
//  DHApiClient.swift
//  DHCommonUtil
//
//  Created by DHLee on 2021/04/27.
//

import Foundation

public enum Result<T, U> where U: Error  {
    case success(T)
    case failure(U)
}


public class DHApiClient {
    
    public static let shared:DHApiClient = DHApiClient()
    
    private func decodingTask<T: Codable>(with request: DHNetwork, decodingType: T.Type, completionHandler completion: @escaping (Codable?, DHApiError?) -> Void) -> URLSessionDataTask {
        
        let req = request.request(with: DHApi.baseURL)
        let task = URLSession.shared.dataTask(with: req) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(nil, .requestFailed)
                return
            }
            
            if httpResponse.statusCode == 200 {
                var tempData = data
                if let _ = tempData, request.dataEncoding != .utf8 {
                    let tempString = String.init(data:tempData!, encoding: request.dataEncoding)
                    tempData = tempString?.data(using: .utf8) ?? nil
                }
                
                if let data = tempData {
                    do {
                        let genericModel = try JSONDecoder().decode(decodingType, from: data)
                        completion(genericModel, nil)
                    } catch {
                        completion(nil, .jsonConversionFailure)
                    }
                } else {
                    completion(nil, .invalidData)
                }
            } else {
                completion(nil, .responseUnsuccessful)
            }
        }
        return task
    }
    
    
    public func fetch<T: Codable>(with request: DHNetwork, completion: @escaping (Result<T, DHApiError>) -> Void) {
        let task = decodingTask(with: request, decodingType: T.self) { (json , error) in
            
            //MARK: change to main queue
            DispatchQueue.main.async {
                guard let json = json else {
                    if let error = error {
                        completion(Result.failure(error))
                    } else {
                        completion(Result.failure(.invalidData))
                    }
                    return
                }
                
                completion(.success(json as! T))
            }
        }
        
        task.resume()
    }
    
    
    /**
     파일을 지정된 경로에 다운로드 한다.
     
     - parameter src: 다운로드 받을 소스 URL
     - parameter dest: 다운로드 받을 경로 URL
     - parameter completion: 다운로드 완료시 실행될 클로저
     
     */
    public func downloadFile(src:URL, dest:URL, completion: @escaping (_ success:Bool) -> ()) {
        
        let task = URLSession.shared.downloadTask(with: src) { tempLocalUrl, response, error in
            
            guard let httpResponse = response as? HTTPURLResponse,
                  let tempLocalUrl = tempLocalUrl else {
                completion(false)
                return
            }
            
            if httpResponse.statusCode == 200 {
                do {
                    try FileManager.default.copyItem(at: tempLocalUrl, to: dest)
                    completion(true)
                    
                } catch (let writeError) {
                    DHLogger.log("error writing file \(dest) : \(writeError)")
                    completion(false)
                }
            }
            else {
                DHLogger.log("error file download with http status code [\(httpResponse.statusCode)]")
                completion(false)
            }
        }
        
        task.resume()
    }
}
