//
//  DataServiceEndpoint.swift
//  AlmindsTask
//
//  Created by Admin on 12/26/21.
//

import UIKit

enum DataServiceEndpoint: String {

    case getUsers, getUserDetails, createUser, updateUser, DeleteUser
    
    enum Method:String {
        case GET
        case POST
        case PUT
        case DELETE
        case PATCH
    }
    
    var endPointInfo: DataServiceEndpointInfo {
        switch self {
        case .getUsers:
            return DataServiceEndpointInfo(scheme: "https", host: "dummyapi.io", port: 0, path: "/data/v1/user", method: .GET)
        case .getUserDetails:
            return DataServiceEndpointInfo(scheme: "https", host: "dummyapi.io", port: 0, path: "/data/v1/user", method: .GET)
        case .createUser:
            return DataServiceEndpointInfo(scheme: "https", host: "dummyapi.io", port: 0, path: "/data/v1/user/create", method: .POST)
        case .updateUser:
            return DataServiceEndpointInfo(scheme: "https", host: "dummyapi.io", port: 0, path: "/data/v1/user", method: .PUT)
        case .DeleteUser:
            return DataServiceEndpointInfo(scheme: "https", host: "dummyapi.io", port: 0, path: "/data/v1/user", method: .DELETE)
        }
    }

}

let appId = "61c84a5bff89f6d268a937e9"

struct DataServiceEndpointInfo {
    var scheme: String!
    var host: String!
    var port: Int!
    var path: String!
    var method: DataServiceEndpoint.Method!
    
    func request(parameters: Dictionary<String,Any>? = nil, body: Dictionary<String,Any>? = nil, pathSuffix: String? = nil) -> URLRequest {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = self.scheme
        if self.port != 0 {
            urlComponents.port = self.port
        }
        urlComponents.host = self.host
        if pathSuffix != nil {
            let updatedPath = self.path + pathSuffix!
            urlComponents.path = updatedPath
        } else {
            urlComponents.path = self.path
        }
        
        var queryString: String?
        
        if (self.method == .GET || self.method == .DELETE) {
            queryString = self.formQueryBodyString(parameters)
        }
        if let _queryString = queryString {
            urlComponents.query = _queryString
        }
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = method.rawValue
        
        if body != nil {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body ?? Dictionary<String,Any>(), options: .fragmentsAllowed)
        }
        
        request.headers = ["app-id": appId]
        
        return request
    }
    
    private func formQueryBodyString(_ parameters: [String: Any]?) -> String? {
        var queryBodyStrings = [String]()
        if let queryBody = parameters, queryBody.values.count > 0 {
            for (key, value) in queryBody {
                queryBodyStrings.append("\(key)=\(value)")
            }
        }
        let queryString = (queryBodyStrings as NSArray).componentsJoined(by: "&")
        return queryString
    }
}

