//
//  Data+Additions.swift
//  AlmindsTask
//
//  Created by Admin on 12/26/21.
//

import Foundation

extension Data {
    func getDecodedObject<T>(from object : T.Type)->T? where T : Decodable {
        
        do {
            
            return try JSONDecoder().decode(object, from: self)
            
        } catch let error {
            
            print("Manually parsed  ", (try? JSONSerialization.jsonObject(with: self, options: .mutableContainers)) ?? "nil")
            
            print("Error in Decoding OBject ", String(describing: error))
            return nil
        }
        
    }
}
