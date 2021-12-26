//
//  DataService.swift
//  AlmindsTask
//
//  Created by Admin on 12/26/21.
//

import Foundation
import Alamofire

class DataService {

    func loadData(endPoint: DataServiceEndpoint, parameters: Dictionary<String,Any>? = nil, body: Dictionary<String,Any>? = nil, pathSuffix: String? = nil, completion:@escaping(Result<Data,ErrorResult>) -> ()) {
       
        var request = endPoint.endPointInfo.request(parameters: parameters, body: body, pathSuffix: pathSuffix)
        
        if !Reachability.shared.isConnected {
            request.cachePolicy = .returnCacheDataDontLoad
        }
        
        AF.request(request).response { (response) in
            if let requestError = response.error {
                completion(.failure(.network(string: "" + requestError.localizedDescription)))
                return
            }
            if let responseData = response.data, responseData.count > 0 {
                completion(.success(responseData))
            }
        }
    }
    
}
