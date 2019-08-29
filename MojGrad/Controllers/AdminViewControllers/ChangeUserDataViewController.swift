//
//  ChangeUserDataViewController.swift
//  MojGrad
//
//  Created by Ja on 22/08/2019.
//  Copyright © 2019 Ja. All rights reserved.
//

import UIKit

class ChangeUserDataViewController: UIViewController {
    
    var editUser = EditUserDataService()
    
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
        let user : String? = userName.text
        let oib = userOib.text ?? ""
        let email = userEmail.text ?? ""
        let password = userPassword.text ?? ""
        
        var firstName : String = ""
        var lastName : String = ""
        
        if user!.count > 0 {
             firstName = user!.components(separatedBy: " ")[0]
            if user!.count > 1 {
                lastName = user!.components(separatedBy: " ")[1]
            }
        }
        let md5Pass = password.md5Value
        
        let param : [String : Any] = ["firstName" : firstName, "lastName" : lastName, "oib" : oib, "email" : email, "password" : md5Pass]
        
        return param
    }
    
    @IBAction func createUserBtn(_ sender: Any) {
        
        let param  = checkUserFields()
        print(param)
        editUser.sendData(parameters: param, requestID: userId) { userJSON in
            guard userJSON != nil else {
                self.showAlert(withTitle: "Error!", withMessage: "Server down!")
                return
            }
            let ok = UIAlertAction(title: "OK", style: .default, handler: { action in
                NotificationCenter.default.post(name: Notification.Name(NewUserController.CONSTANT_REFRESH_USERS), object: nil)
                let storyboard = UIStoryboard.init(name: "NewUser", bundle: nil)
                let destination = storyboard.instantiateViewController(withIdentifier: "allUsers")
                self.navigationController?.pushViewController(destination, animated: true)

                })
                self.showAlert(withTitle: "Super", withMessage: "Korisnik uspješno promijenjen", okAction: ok)
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
