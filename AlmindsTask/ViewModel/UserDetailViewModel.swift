//
//  UserDetailViewModel.swift
//  AlmindsTask
//
//  Created by Admin on 12/26/21.
//

import Foundation

class UserDetailViewModel {
    
    weak var controller: UserDetailViewController!
    
    init(controller: UserDetailViewController) {
        self.controller = controller
    }
    
    var userDetail: UserDetail? {
        didSet {
            self.controller?.setUserDetail(self.userDetail)
        }
    }
    
    var userDateOfBirth: Date?
    
    func getUserDetail() {
        ServiceManager.shared.getUserDetail(UserDetailReq(user_id: self.controller?.user_id ?? "")) { (result, error) in
            if error == nil {
                self.userDetail = result
            } else {
                //
            }
        }
    }
    
    func createUser() {
        ServiceManager.shared.getUserDetail(UserDetailReq(user_id: nil, firstName: self.controller?.firstNameTxtField?.text, lastName: self.controller?.lastNameTxtField?.text, email: self.controller?.emailTxtField?.text, picture: "https://image.shutterstock.com/image-vector/user-design-600w-286920887.jpg")) { (result, error) in
            if error == nil {
                self.userDetail = result
                self.controller?.showAlert("User Created Successfully", isNeedsToPop: true)
            } else {
                //
            }
        }
    }
}
