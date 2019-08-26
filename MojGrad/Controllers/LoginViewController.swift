//
//  LoginViewController.swift
//  MojGrad
//
//  Created by Ja on 30/07/2019.
//  Copyright © 2019 Ja. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    var emailFieldCheck = false {
        didSet {
            correctInputs = emailFieldCheck && passFieldCheck
        }
    }
    var passFieldCheck = false {
        didSet {
            correctInputs = emailFieldCheck && passFieldCheck
        }
    }
    
    var correctInputs = false {
        didSet {
            loginButton.isEnabled = correctInputs
            rememberMeButton.isEnabled = correctInputs
            if loginButton.isEnabled && rememberMeButton.isEnabled {
                loginButton.alpha = 1
                rememberMeButton.alpha = 1
                checkmarkImage.alpha = 1
                rememberMeLabel.alpha = 1
            }
        }
    }
    var isOn = false
    var log = RegData()
    var pass: String =  ""
    var loginService = LoginService()
    
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
            UserDefaults.standard.set(true, forKey: Keys.rememberMe)
            
        } else {
            rememberMeLabel.text = "Zapamti me"
            checkmarkImage.image = UIImage(named: "remember_me_checkmark_icon")
            UserDefaults.standard.set(false, forKey: Keys.rememberMe)
            
        }
    }
    
    
    @IBAction func logInButtonTapped(_ sender: UIButton) {
        guard let email = emailField.text else {
            return
        }
        guard let password = passwordField.text else {
            return
        }
        
        let md5Pass = password.md5Value
        
        let param : [String : String] = ["email" : email, "password" : md5Pass]
        
        self.showSpinner(onView: self.view)
        
        loginService.fetchData(parameters: param) { logJSON in
            guard let data = logJSON else {
                DispatchQueue.main.async {
                    self.showAlert(withTitle: "Error!", withMessage: "Server down!")
                }
                return
            }
            if let jwt = data["data"]["user"]["jwt"].string {
                let personRoleId = data["data"]["user"]["personsRoleId"].intValue
                UserDefaults.standard.set(jwt, forKey: Keys.jasonWebToken)
                UserDefaults.standard.set(personRoleId, forKey: Keys.personRoleId)
                if personRoleId == 1{
                    self.performSegue(withIdentifier: "Admin", sender: nil)
                }
            }
            else if let _ = data["data"]["error"]["error_code"].string {
                let errDescription = data["data"]["error"]["error_description"].stringValue
                self.showAlert(withTitle: "Error!", withMessage: errDescription)
                self.removeSpinner()
                
            }
        }
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
}

