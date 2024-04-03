//
//  DHResBase.swift
//  DHCommonUtil
//
//  Created by DHLee on 2021/04/27.
//

import Foundation


public struct DHResBase: Codable, DHCodable {
    var result: String?
    var resultCode: String?
    
    private enum CodingKeys: String, CodingKey {
        case result = "resultMessage"
        case resultCode = "resultCode"
    }
    
}



