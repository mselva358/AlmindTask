//
//  User.swift
//  AlmindsTask
//
//  Created by Admin on 12/26/21.
//

import Foundation

struct User: JSONSerializable {
    var id: String!
    var title: String!
    var firstName: String!
    var lastName: String!
    var picture: String!
    
    var fullName: String {
        return [(self.title ?? "").capitalized, [(self.firstName ?? ""), (self.lastName ?? "")].joined(separator: " ")].joined(separator: ". ")
    }
}

struct GetUsersReq: JSONSerializable {
    var page, limit: Int!
}

class GetUsersRes: JSONSerializable {
    var total, page, limit: Int?
    var data: [User] = []
}
