//
//  DHResTEST.swift
//  DHCommonUtil
//
//  Created by DHLee on 2021/04/27.
//

import Foundation

public struct DHResTEST: Codable, DHCodable {
    //공통
    var returnValue: String?
    
    //성공시 포함
    var totSellamnt: Double?
    var firstAccumamnt: Double?
    var drwNoDate: String?
    var firstWinamnt: Int?
    var drwNo: Int?
    var drwtNo1: Int?
    var drwtNo2: Int?
    var drwtNo3: Int?
    var drwtNo4: Int?
    var drwtNo5: Int?
    var drwtNo6: Int?
    var bnusNo: Int?
    var firstPrzwnerCo: Int?
    
    
    private enum CodingKeys: String, CodingKey {
        case returnValue = "returnValue"
        
        //성공시 포함
        case totSellamnt = "totSellamnt"
        case firstAccumamnt = "firstAccumamnt"
        case drwNoDate = "drwNoDate"
        case firstWinamnt = "firstWinamnt"
        case drwNo = "drwNo"
        case drwtNo1 = "drwtNo1"
        case drwtNo2 = "drwtNo2"
        case drwtNo3 = "drwtNo3"
        case drwtNo4 = "drwtNo4"
        case drwtNo5 = "drwtNo5"
        case drwtNo6 = "drwtNo6"
        case bnusNo = "bnusNo"
        case firstPrzwnerCo = "firstPrzwnerCo"
    }
    
}



