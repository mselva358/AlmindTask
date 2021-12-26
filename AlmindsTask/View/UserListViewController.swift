//
//  UserListViewController.swift
//  AlmindsTask
//
//  Created by Admin on 12/26/21.
//

import UIKit
import Haneke

class UserListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: UserListViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = UserListViewModel(controller: self)
        
        viewModel?.getUsers()
        
        // Do any additional setup after loading the view.
    }
    
    func reloadList() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView?.reloadData()
        }
    }
    
    fileprivate func showUserDetail(_ user: User?, isForEdit: Bool = false) {
        let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserDetailViewController") as! UserDetailViewController
        detailVC.user_id = user?.id
        detailVC.isForCreatingUser = isForEdit
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CreateUser" {
            (segue.destination as? UserDetailViewController)?.isForCreatingUser = true
        }
    }

}

extension UserListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.userListRes?.data.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserListTableViewCell", for: indexPath) as! UserListTableViewCell
        let user = self.viewModel?.userListRes?.data[indexPath.row]
        cell.setValues(user)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = self.viewModel?.userListRes?.data[indexPath.row]
        self.showUserDetail(user)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == ((viewModel?.userListRes?.data.count ?? 0) - 1) {
            viewModel?.loadNext((viewModel.userListRes?.page ?? 0) + 1)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let user = self.viewModel?.userListRes?.data[indexPath.row]
        if (editingStyle == .delete) {
            self.viewModel?.deleteUser(user)
        } else if editingStyle == .none {
            
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//
//        let user = self.viewModel?.userListRes?.data[indexPath.row]
//        let editAction = UITableViewRowAction(style: .default, title: "Edit", handler: { [weak self] (action, indexPath) in
//            self?.showUserDetail(user, isForEdit: true)
//        })
//        editAction.backgroundColor = UIColor.blue
//
//        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { [weak self] (action, indexPath) in
//            self?.viewModel?.deleteUser(user)
//        })
//        deleteAction.backgroundColor = UIColor.red
//
//        return [editAction, deleteAction]
//    }
}

class UserListTableViewCell: UITableViewCell {
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    
    func setValues(_ user: User?) {
        self.userImage?.loadImage(user?.picture ?? "")
        self.userName?.text = user?.fullName
    }
}

extension ServiceManager {
    
    func getUsers(_ req: GetUsersReq, completion: ((GetUsersRes?, Error?)->Void)? = nil) {
        self.loadData(endPoint: DataServiceEndpoint.getUsers, parameters: req.JSONRepresentation) { (result) in
            switch result {
            case .success(let data):
                let res = data.getDecodedObject(from: GetUsersRes.self)
                completion?(res, nil)
            case .failure(let error):
                completion?(nil, error)
            }
        }
    }
    
    func deleteUser(_ userId: String!, completion: ((GetUsersRes?, Error?)->Void)? = nil) {
        self.loadData(endPoint: DataServiceEndpoint.DeleteUser, pathSuffix: "/\(userId ?? "")") { (result) in
            switch result {
            case .success(let data):
                let res = data.getDecodedObject(from: GetUsersRes.self)
                completion?(res, nil)
            case .failure(let error):
                completion?(nil, error)
            }
        }
    }
    
    func updateUser(_ req: UpdateUserReq, completion: ((GetUsersRes?, Error?)->Void)? = nil) {
        self.loadData(endPoint: DataServiceEndpoint.updateUser, body: req.JSONRepresentation, pathSuffix: "/\(req.user_id ?? "")") { (result) in
            switch result {
            case .success(let data):
                let res = data.getDecodedObject(from: GetUsersRes.self)
                completion?(res, nil)
            case .failure(let error):
                completion?(nil, error)
            }
        }
    }
}

extension UIImageView {
    func loadImage(_ urlString: String) {
        if let url = URL(string: urlString) {
            self.hnk_setImage(from: url, placeholder: nil) { [weak self] (image) in
                DispatchQueue.main.async { [weak self] in
                    self?.image = image
                }
            } failure: { (error) in
                
            }
        }
    }
}


struct UpdateUserReq: JSONSerializable {
    var user_id: String!
}
