//
//  DHCodable.swift
//  DHCommonUtil
//
//  Created by DHLee on 2021/04/27.
//



public protocol DHCodable {
    var json:String? { get }
    var debugDescription: String { get }
}


public extension DHCodable where Self: Codable {
    
    var json:String? {
        do {
            let jsonData = try JSONEncoder().encode(self)
            
            return String(data: jsonData, encoding: .utf8)
        }
        catch {
        }
        
        return nil
    }
    
    var debugDescription: String {
        return self.json ?? ">>> EMPTY <<<"
    }
}


