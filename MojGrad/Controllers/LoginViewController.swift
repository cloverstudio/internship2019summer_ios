//
//  LoginViewController.swift
//  MojGrad
//
//  Created by Ja on 30/07/2019.
//  Copyright © 2019 Ja. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    var isOn = false
    let defaults = UserDefaults.standard
    var pass: String =  ""
    
    @IBOutlet weak var logoView: UIImageView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var contextLabel: UITextView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registrationButton: UIButton!
    @IBOutlet weak var passIsNotSee: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailField.setBottomBorder()
        passwordField.setBottomBorder()
        loginButton.setUpButton()
        passwordField.isSecureTextEntry = true
        loginButton.isEnabled = false
        passwordField.delegate = self
        
        
        defaults.set("avion123", forKey: "passs")
        pass = defaults.string(forKey: "passs") ?? ""
        print(pass)
    }
    
    @IBAction func passButtonTapped(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            passwordField.isSecureTextEntry = false
        } else {
            passwordField.isSecureTextEntry = true
        }
       
    }

    @IBAction func logInButtonTapped(_ sender:
        UIButton) {
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if ((textField.text ?? "") + string == pass) {
            loginButton.isEnabled = true
            loginButton.alpha = 1
            print("Right pass")
        } else {
            loginButton.isEnabled = false
            loginButton.alpha = 0.5
            print("Wrong pass")
        }
        return true
    }
    

}
