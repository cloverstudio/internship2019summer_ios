//
//  LoginViewController.swift
//  MojGrad
//
//  Created by Ja on 30/07/2019.
//  Copyright © 2019 Ja. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    var emailFieldCheck = false { didSet {
        allOK = emailFieldCheck && passFieldCheck
        }
    }
    var passFieldCheck = false { didSet {
        allOK = emailFieldCheck && passFieldCheck
        }
    }
    
    var allOK = false { didSet {
        loginButton.isEnabled = allOK
        if loginButton.isEnabled {
            loginButton.alpha = 1
        }
        }
    }

    var isOn = false
    let defaults = UserDefaults.standard
    var pass: String =  ""
    
    @IBOutlet weak var logoView: UIImageView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var contextLabel: UITextView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    
    //Fields for user to log in
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    
    @IBOutlet weak var rememberMeButton: UIButton!
    //Checkmark Image and remember me label are under remember me button
    @IBOutlet weak var checkmarkImage: UIImageView!
    @IBOutlet weak var rememberMeLabel: UILabel!
    
    @IBOutlet weak var loginButton: UIButton!
    
    //Button to Registration
    @IBOutlet weak var registrationButton: UIButton!
    
    //Button to show/hide password
    @IBOutlet weak var passIsNotSee: UIButton!
    
    //Labels for validation
    @IBOutlet weak var validEmailLabel: UILabel!
    @IBOutlet weak var validPassLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailField.setBottomBorder()
        passwordField.setBottomBorder()
        
        passwordField.isSecureTextEntry = true
        loginButton.isEnabled = false
        rememberMeButton.isEnabled = false
        
        validEmailLabel.isHidden = true
        validPassLabel.isHidden = true
        
        emailField.addTarget(self, action: #selector(checkEmail), for: .editingChanged)
        passwordField.addTarget(self, action: #selector(checkPass), for: .editingChanged)

        checkForData()
    }
    
    @IBAction func passButtonTapped(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            passwordField.isSecureTextEntry = false
        } else {
            passwordField.isSecureTextEntry = true
        }
       
    }
    
    @IBAction func rememberMeButtonTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            rememberMeLabel.text = "Zaboravi me"
            checkmarkImage.image = UIImage(named: "remember_me_x_icon")
        } else {
            rememberMeLabel.text = "Zapamti me"
            checkmarkImage.image = UIImage(named: "remember_me_checkmark_icon")
        }
    }
    
    
    @IBAction func logInButtonTapped(_ sender: UIButton) {
    }
    
    func isValidEmail(emailID:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: emailID)
    }
    
    @objc
    func checkEmail(){
        guard let email = emailField.text, emailField.text?.count != 0 else {return}
        if isValidEmail(emailID: email) == false {
            validEmailLabel.isHidden = false
            validEmailLabel.text = "Email nije validan"
        } else {
            validEmailLabel.isHidden = true
            emailFieldCheck = true
        }
    }
    
    @objc
    func checkPass() {
        if passwordField.text!.count < 6 {
            validPassLabel.isHidden = false
            validPassLabel.text = "Pass je prekratak!"
        } else {
            validPassLabel.isHidden = true
            passFieldCheck = true
        }
    }
    
    func checkForData()  {
        let email = defaults.string(forKey: Keys.userEmail) ?? ""
        emailField.text = email
        
        let password = defaults.string(forKey: Keys.userPass) ?? ""
        passwordField.text = password
        
        if passwordField.text != "" && emailField.text != "" {
            loginButton.isEnabled = true
            loginButton.alpha = 1
            rememberMeButton.isEnabled = true
            rememberMeButton.alpha = 1
            checkmarkImage.alpha = 1
            rememberMeLabel.alpha = 1
        }
    }
    
    
}

