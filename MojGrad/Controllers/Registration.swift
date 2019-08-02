//
//  RegistrationViewController.swift
//  MojGrad
//
//  Created by Ja on 29/07/2019.
//  Copyright © 2019 Ja. All rights reserved.
//

import UIKit

class Registration: UIViewController {
    
    let defaults = UserDefaults.standard
    
    var oibFieldCheck = false { didSet {
        allOK = oibFieldCheck && emailFieldCheck && passFieldCheck
        }
    }
    var emailFieldCheck = false { didSet {
        allOK = oibFieldCheck && emailFieldCheck && passFieldCheck
        }
    }
    var passFieldCheck = false { didSet {
        allOK = oibFieldCheck && emailFieldCheck && passFieldCheck
        }
    }
    
    var allOK = false { didSet {
        registrationButton.isEnabled = allOK
        if registrationButton.isEnabled {
            registrationButton.alpha = 1
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
        
        oibField.addTarget(self, action: #selector(checkOib), for: .editingChanged)
        emailField.addTarget(self, action: #selector(checkEmail), for: .editingChanged)
        passField.addTarget(self, action: #selector(checkPass), for: .editingChanged)
    
        checkForUserData()
    }
    
    @IBAction func registrationButtonTapped(_ sender: Any) {
        saveUserData()
    }
    
    @IBAction func passIconTapped(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            passField.isSecureTextEntry = false
        } else {
            passField.isSecureTextEntry = true
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
    
    func saveUserData() {
        defaults.set(oibField.text!, forKey: Keys.userOib)
        defaults.set(emailField.text!, forKey: Keys.userEmail)
        defaults.set(passField.text!, forKey: Keys.userPass)
        defaults.set(true, forKey: Keys.userRegistered)
        
    }
    
    func checkForUserData() {
        let oib = defaults.value(forKey: Keys.userOib) as? String ?? ""
        oibField.text = oib

        let email = defaults.value(forKey: Keys.userEmail) as? String ?? ""
        emailField.text = email

        let pass = defaults.value(forKey: Keys.userPass) as? String ?? ""
        passField.text = pass
    }
}
