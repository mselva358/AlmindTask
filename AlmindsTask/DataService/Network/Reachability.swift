//
//  Reachability.swift
//  AlmindsTask
//
//  Created by Admin on 12/26/21.
//

import Foundation
import Alamofire

class Reachability: NSObject {
    static let shared = Reachability()
    private var manager: NetworkReachabilityManager
    
    private override init() {
        self.manager = NetworkReachabilityManager()!
        super.init()
        
    }
    
    var isConnected: Bool {
        return manager.isReachable
    }
    
}
