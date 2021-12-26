//
//  JSONSerializable.swift
//  AlmindsTask
//
//  Created by Admin on 12/26/21.
//

import Foundation

protocol JSONSerializable : Codable {
    var JSONRepresentation : [String : Any] { get }
}

extension JSONSerializable {
    
    var JSONRepresentation : [String : Any] {
        
        var representation = [String:Any]()
        
        for case let (label?, value) in Mirror(reflecting: self).children {
            
            switch value {
            case let value as Dictionary<String,Any>:
                
                representation[label] = value as AnyObject
                
            case let value as Array<Any>:
                
                if let val = value as? [JSONSerializable]{
                    representation[label] = val.map({ $0.JSONRepresentation as AnyObject}) as AnyObject
                } else {
                    representation[label] = value as AnyObject
                }
                
            case let value as JSONSerializable:
                
                representation[label] = value.JSONRepresentation
                
            case let value as AnyObject? :
                if value != nil {
                    representation[label] = value
                }
            default: break
            }
        }
        return representation
    }
    
    // Convert to data by Encoding
    
    func toData()->Data? {
        
        do {
            
            return try JSONEncoder().encode(self)
            
        } catch let err {
            print("Error in Encoding ", self.JSONRepresentation, err.localizedDescription)
            return nil
        }
        
    }
    
}
