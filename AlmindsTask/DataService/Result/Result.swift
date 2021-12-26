//
//  Result.swift
//  AlmindsTask
//
//  Created by Admin on 12/26/21.
//

import Foundation

enum Result<T,E:Error> {
    case success(T)
    case failure(E)
}
