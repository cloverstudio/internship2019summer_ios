//
//  NewUserController.swift
//  MojGrad
//
//  Created by Ja on 08/08/2019.
//  Copyright © 2019 Ja. All rights reserved.
//

import UIKit

class NewUserController: UIViewController {
    
    static let CONSTANT_REFRESH_USERS = "CONSTANT_REFRESH_USERS"
    var newUser = AddNewUserService()
    
    @IBOutlet weak var newProfileImageButton: UIButton!
    //User info fields
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var oibField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passField: UITextField!
    //Button funcionality
    @IBOutlet weak var showPassButton: UIButton!
    @IBOutlet weak var addNewUser: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBordersForFields()
        
        passField.isSecureTextEntry = true
        
        addNewUser.isEnabled = true
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        newProfileImageButton.layer.cornerRadius = newProfileImageButton.frame.size.width/2
    }
    
    func setBordersForFields() {
        usernameField.setBottomBorder()
        oibField.setBottomBorder()
        emailField.setBottomBorder()
        passField.setBottomBorder()
    }
    
    @IBAction func showPassIconTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            passField.isSecureTextEntry = false
        } else {
            passField.isSecureTextEntry = true
        }
    }
    @IBAction func addNewUser(_ sender: UIButton) {
        guard let userName = usernameField.text else { return }
        guard let oib = oibField.text else { return }
        guard let email = emailField.text else { return }
        guard let password = passField.text else { return }
        
        let md5Pass = password.md5Value
        
        let userParam : [String : String] = ["userName" : userName, "firstName" : userName, "oib" : oib, "email" : email, "password" : md5Pass]
        
        newUser.sendUserData(parameters: userParam) { userJSON in
            guard let data = userJSON else {
                self.showAlert(withTitle: "Error!", withMessage: "Server down!")
                return
            }
            if let _ = data["data"]["user"]["id"].int {
                let ok = UIAlertAction(title: "OK", style: .default, handler: { action in
                    NotificationCenter.default.post(name: Notification.Name(NewUserController.CONSTANT_REFRESH_USERS), object: nil)
                    self.navigationController?.popViewController(animated: true)
                    
                })
                self.showAlert(withTitle: "Super", withMessage: "Korisnik uspješno kreiran", okAction: ok)
            }
            else if let _ = data["data"]["error"]["error_code"].string {
                let errDescription = data["data"]["error"]["error_description"].stringValue
                self.showAlert(withTitle: "Error!", withMessage: errDescription)
            }
        }
    }
}
    

