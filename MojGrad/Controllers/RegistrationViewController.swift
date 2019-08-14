//
//  RegistrationViewController.swift
//  MojGrad
//
//  Created by Ja on 29/07/2019.
//  Copyright © 2019 Ja. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class RegistrationViewController: UIViewController {

    var registrationService = RegistrationService()
    
    var reg = RegData()
    
    var oibFieldCheck = false {
        didSet {
            correctInputs = oibFieldCheck && emailFieldCheck && passFieldCheck
        }
    }
    var emailFieldCheck = false {
        didSet {
            correctInputs = oibFieldCheck && emailFieldCheck && passFieldCheck
        }
    }
    var passFieldCheck = false {
        didSet {
            correctInputs = oibFieldCheck && emailFieldCheck && passFieldCheck
        }
    }
    
    var correctInputs = false { didSet {
        registrationButton.isEnabled = correctInputs
        rememberMeButton.isEnabled = correctInputs
        if registrationButton.isEnabled && rememberMeButton.isEnabled {
            registrationButton.alpha = 1
            rememberMeButton.alpha = 1
            checkmarkImage.alpha = 1
            rememberMeLabel.alpha = 1
        }
        }
    }

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var oibLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    //Taxefields for users info
    @IBOutlet weak var oibField: UITextField!
    @IBOutlet weak var passField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    
    //Checkmark image and remember label are under remember me button
    @IBOutlet weak var rememberMeButton: UIButton!
    @IBOutlet weak var checkmarkImage: UIImageView!
    @IBOutlet weak var rememberMeLabel: UILabel!
    
    @IBOutlet weak var registrationButton: UIButton!
    @IBOutlet weak var passIcon: UIButton!
    //Labels for validation
    @IBOutlet weak var validOibLabel: UILabel!
    @IBOutlet weak var validEmailLabel: UILabel!
    @IBOutlet weak var validPassLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Design for bottom border on TextFields
        oibField.setBottomBorder()
        emailField.setBottomBorder()
        passField.setBottomBorder()
        
        validOibLabel.isHidden = true
        validEmailLabel.isHidden = true
        validPassLabel.isHidden = true
        
        passField.isSecureTextEntry = true
        registrationButton.isEnabled = false
        rememberMeButton.isEnabled = false
        
        oibField.addTarget(self, action: #selector(checkOib), for: .editingChanged)
        emailField.addTarget(self, action: #selector(checkEmail), for: .editingChanged)
        passField.addTarget(self, action: #selector(checkPass), for: .editingChanged)
        
    }
    
    @IBAction func registrationButtonTapped(_ sender: Any) {
        guard let oib = oibField.text else {
            return
        }
        guard let email = emailField.text else {
            return
        }
        guard let pass = passField.text else {
            return
        }
        
        let md5Pass = pass.md5Value
        
        let param : [String : String] = ["oib" : oib, "email" : email, "password" : md5Pass]
        
        self.showSpinner(onView: self.view)
        
        registrationService.sendData(parameters: param) { regJSON  in
            guard let data = regJSON else {
                DispatchQueue.main.async {
                    self.showAlert(withTitle: "Error!", withMessage: "Server down!")
                }
                return
            }
            
            if let jwt = data["data"]["user"]["jwt"].string {
                self.reg.jwt = jwt
                self.reg.personRoleId = data["data"]["user"]["personsRoleId"].intValue
                UserDefaults.standard.set(self.reg.jwt, forKey: Keys.jasonWebToken)
                UserDefaults.standard.set(self.reg.personRoleId, forKey: Keys.personRoleId)
                self.performSegue(withIdentifier: "NewsFeed", sender: nil)
                
            }
            else if let tmpError = data["data"]["error"]["error_code"].string {
                if tmpError == "1002" {
                    let errDescription = data["data"]["error"]["error_description"].stringValue
                    self.showAlert(withTitle: "Error!", withMessage: errDescription)
                    self.removeSpinner()
                    
                } else if tmpError == "1003"{
                    let errDescription = data["data"]["error"]["error_description"].stringValue
                    self.showAlert(withTitle: "Error!", withMessage: errDescription)
                    self.removeSpinner()
                }
            }
        }
    }

    
    @IBAction func passIconTapped(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            passField.isSecureTextEntry = false
        } else {
            passField.isSecureTextEntry = true
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
    
    
    func isValidEmail(emailID:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: emailID)
    }
    
    @objc
    func checkOib(){
        if oibField.text!.count < 11 {
            validOibLabel.isHidden = false
            validOibLabel.text = "OIB je premali!"
        } else {
            validOibLabel.isHidden = true
            oibFieldCheck = true
        }
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
    func checkPass(){
        if passField.text!.count < 6 {
            validPassLabel.isHidden = false
            validPassLabel.text = "Pass je prekratak!"
        } else {
            validPassLabel.isHidden = true
            passFieldCheck = true
        }
    }
}

