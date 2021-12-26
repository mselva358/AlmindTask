//
//  UserListViewModel.swift
//  AlmindsTask
//
//  Created by Admin on 12/26/21.
//

import Foundation

let limit = 10

class UserListViewModel {
    
    weak var controller: UserListViewController!
    
    init(controller: UserListViewController) {
        self.controller = controller
    }
        
    var userListRes: GetUsersRes?
    
    func getUsers(_ page: Int = 1) {
        ServiceManager.shared.getUsers(GetUsersReq(page: page, limit: limit)) { [weak self] (result, error) in
            if error == nil {
                if self?.userListRes == nil {
                    self?.userListRes = result
                    self?.controller?.reloadList()
                } else {
                    self?.userListRes?.total = result?.total
                    self?.userListRes?.page = result?.page
                    self?.userListRes?.limit = result?.limit
                    self?.userListRes?.data.append(contentsOf: result?.data ?? [])
                    self?.controller?.reloadList()
                }
            } else {
                //
            }
        }
    }
    
    func loadNext(_ page: Int) {
        if (self.userListRes?.total ?? 0) > (self.userListRes?.page ?? 0) {
            self.getUsers(page)
        }
    }
    
    func deleteUser(_ user: User?) {
        ServiceManager.shared.deleteUser(user?.id) { [weak self] (result, error) in
            if error == nil {
                self?.controller?.showAlert("User Deleted Successfully")
                self?.userListRes = nil
                self?.getUsers()
            }
        }
    }
}
