//
//  ChangeUserDataViewController.swift
//  MojGrad
//
//  Created by Ja on 22/08/2019.
//  Copyright © 2019 Ja. All rights reserved.
//

import UIKit

class ChangeUserDataViewController: UIViewController {
    
    var newUser = AddNewUserService()
    
    @IBOutlet weak var btnPicture: UIButton!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var userOib: UITextField!
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var userPassword: UITextField!
    @IBOutlet weak var userBtn: UIButton!
    @IBOutlet weak var showPassIcon: UIButton!
    
    var userId : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userPassword.isSecureTextEntry = true
        
    }
    func checkUserFields() -> [String : Any] {
        let user = userName.text ?? ""
        let oib = userOib.text ?? ""
        let email = userEmail.text ?? ""
        let password = userPassword.text ?? ""
        print(oib)
        let id = userId ?? 0
        
        let firstName = user.components(separatedBy: " ")[0] ?? ""
        let lastName = user.components(separatedBy: " ")[1]  ?? ""
        
        let md5Pass = password.md5Value
        
        let param : [String : Any] = ["firstName" : firstName, "lastName" : lastName, "oib" : oib, "email" : email, "password" : md5Pass, "id" : id]
        
        //let parameters = param.compactMapValues { $0 }
        
        //param.filter { $0.value != nil }.mapValues { $0 }
        
        //print(param)
        return param
    }
    
    @IBAction func createUserBtn(_ sender: Any) {
        
        let param  = checkUserFields()

        newUser.sendUserData(parameters: param) { userJSON in
            guard let data = userJSON else {
                self.showAlert(withTitle: "Error!", withMessage: "Server down!")
                return
            }
            if let _ = data["data"]["user"]["email"].string {
                //print(data["data"]["user"]["email"].string)
                let ok = UIAlertAction(title: "OK", style: .default, handler: { action in
                   NotificationCenter.default.post(name: Notification.Name(NewUserController.CONSTANT_REFRESH_USERS), object: nil)
                    self.navigationController?.popViewController(animated: true)

                })
                self.showAlert(withTitle: "Super", withMessage: "Korisnik uspješno promijenjen", okAction: ok)
            }
            else if let _ = data["data"]["error"]["error_code"].string {
                let errDescription = data["data"]["error"]["error_description"].stringValue
                self.showAlert(withTitle: "Error!", withMessage: errDescription)
            }
        }
    }
    @IBAction func showPassIconTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            userPassword.isSecureTextEntry = false
        } else {
            userPassword.isSecureTextEntry = true
        }
    }
    
}
