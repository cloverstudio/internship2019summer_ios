//
//  NewUserController.swift
//  MojGrad
//
//  Created by Ja on 08/08/2019.
//  Copyright © 2019 Ja. All rights reserved.
//

import UIKit

class NewUserController: UIViewController {
    
    @IBOutlet weak var newProfileImageButton: UIButton!
    //User info fields
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var oibField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passField: UITextField!
    //Button funcionality
    @IBOutlet weak var showPassButton: UIButton!
    @IBOutlet weak var createUserButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameField.setBottomBorder()
        oibField.setBottomBorder()
        emailField.setBottomBorder()
        passField.setBottomBorder()
        
        passField.isSecureTextEntry = true
        
        createUserButton.isEnabled = false
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        newProfileImageButton.layer.cornerRadius = newProfileImageButton.frame.size.width/2
    }
    
    
    @IBAction func showPassIconTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            passField.isSecureTextEntry = false
        } else {
            passField.isSecureTextEntry = true
        }
    }
    
    
}


