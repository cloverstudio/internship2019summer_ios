//
//  LoginViewController.swift
//  MojGrad
//
//  Created by Ja on 30/07/2019.
//  Copyright © 2019 Ja. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var logoView: UIImageView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var contextLabel: UITextView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailField.setBottomBorder()
        passwordField.setBottomBorder()
    }
    
    

}
