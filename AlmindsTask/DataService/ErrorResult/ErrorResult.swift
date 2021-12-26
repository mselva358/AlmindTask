//
//  ErrorResult.swift
//  AlmindsTask
//
//  Created by Admin on 12/26/21.
//

import Foundation

enum ErrorResult:Error {
    case network(string:String)
    case parser(string:String)
    case custom(string:String)
}
