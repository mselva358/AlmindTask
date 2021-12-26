//
//  UserDetailViewController.swift
//  AlmindsTask
//
//  Created by Admin on 12/26/21.
//

import UIKit

class UserDetailViewController: UIViewController {
    
    var isForCreatingUser: Bool = false
    var isForEditingUser: Bool = false
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var firstNameTxtField: UITextField!
    @IBOutlet weak var lastNameTxtField: UITextField!
    @IBOutlet weak var genderTxtField: UITextField!
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var dobTxtField: UITextField!
    @IBOutlet weak var phoneTxtField: UITextField!
    @IBOutlet weak var addressLbl: UILabel!
    
    @IBOutlet weak var datePicker: UIDatePicker! {
        didSet {
            self.datePicker?.maximumDate = Date()
            self.datePicker?.preferredDatePickerStyle = .wheels
        }
    }
    
    @IBOutlet weak var pickerContainer: UIView!
    
    var user_id: String!
    
    var viewModel: UserDetailViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewModel = UserDetailViewModel(controller: self)
        
        self.viewModel?.getUserDetail()
        
        self.setupUI()
        
        // Do any additional setup after loading the view.
    }
    
    private func setupUI() {
        [
            firstNameTxtField,
            lastNameTxtField,
            genderTxtField,
            emailTxtField,
            dobTxtField,
            phoneTxtField
        ].forEach {
            $0?.delegate = self
            if isForCreatingUser == false {
                $0?.isUserInteractionEnabled = false
            }
        }
        self.pickerContainer?.isHidden = true
        self.addressLbl?.superview?.isHidden = isForCreatingUser
        if isForCreatingUser == false {
            self.navigationItem.rightBarButtonItems = []
        }
    }
    
    func setUserDetail(_ userDetail: UserDetail?) {
        self.viewModel?.userDateOfBirth = userDetail?.dateOfBirth?.date
        self.userImage?.loadImage(userDetail?.picture ?? "")
        self.firstNameTxtField?.text = userDetail?.firstName
        self.lastNameTxtField?.text = userDetail?.lastName
        self.genderTxtField?.text = userDetail?.gender
        self.emailTxtField?.text = userDetail?.email
        self.dobTxtField?.text = userDetail?.dateOfBirth?.date?.toDOB()
        self.phoneTxtField?.text = userDetail?.phone
        self.addressLbl?.text = userDetail?.location?.address
    }
    
    @IBAction func setDateOfBirth(_ sender: Any) {
        self.viewModel?.userDateOfBirth = self.datePicker?.date
        self.dobTxtField?.text = self.datePicker?.date.stringFromFormat()
        self.pickerContainer?.isHidden = true
    }
    
    @IBAction func dismissDateOfBirthSelection(_ sender: Any) {
        self.pickerContainer?.isHidden = true
    }
    
    @IBAction func createUser(_ sender: Any) {
        guard self.firstNameTxtField?.text != nil && self.firstNameTxtField?.text?.isEmpty == false else {
            self.showAlert("Enter Your First Name")
            return
        }
        guard self.lastNameTxtField?.text != nil && self.lastNameTxtField?.text?.isEmpty == false else {
            self.showAlert("Enter Your Last Name")
            return
        }
        guard self.emailTxtField?.text != nil && self.emailTxtField?.text?.isEmpty == false else {
            self.showAlert("Enter Your Email")
            return
        }
        self.viewModel?.createUser()
    }
}

extension UserDetailViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == dobTxtField {
            self.pickerContainer?.isHidden = false
            return false
        }
        return true
    }
}

extension ServiceManager {
    func getUserDetail(_ req: UserDetailReq, completion: ((UserDetail?, Error?)->Void)? = nil) {
        self.loadData(endPoint: DataServiceEndpoint.getUserDetails, pathSuffix: "/\(req.user_id ?? "")") { (result) in
            switch result {
            case .success(let data):
                let res = data.getDecodedObject(from: UserDetail.self)
                completion?(res, nil)
            case .failure(let error):
                completion?(nil, error)
            }
        }
    }
    
    func createUser(_ req: UserDetailReq, completion: ((UserDetail?, Error?)->Void)? = nil) {
        self.loadData(endPoint: DataServiceEndpoint.createUser, body: req.JSONRepresentation) { (result) in
            switch result {
            case .success(let data):
                let res = data.getDecodedObject(from: UserDetail.self)
                completion?(res, nil)
            case .failure(let error):
                completion?(nil, error)
            }
        }
    }
}

struct UserDetailReq: JSONSerializable {
    var user_id: String!
    var firstName, lastName, email: String!
    var picture: String!
}

struct UserDetail: JSONSerializable {
    var id, title, firstName, lastName: String?
    var picture: String?
    var gender, email, dateOfBirth, phone: String?
    var location: Location?
    var registerDate, updatedDate: String?
}

struct Location: JSONSerializable {
    var street, city, state, country: String?
    var timezone: String?
}

extension Date {
    func stringFromFormat(_ format: String = "dd-MMM-yyyy") -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    func toDOB(_ format: String = "dd-MMM-yyyy") -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}

extension String {
    var date: Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return formatter.date(from: self)
    }
}

extension Location {
    var address: String? {
        return [(street ?? ""), (city ?? ""), (state ?? ""), (country ?? "")].joined(separator: ", ")
    }
}

extension UIViewController {
    func showAlert(_ message: String?, isNeedsToPop: Bool = false) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: { [weak self] (action) in
            if isNeedsToPop {
                self?.navigationController?.popViewController(animated: true)
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
