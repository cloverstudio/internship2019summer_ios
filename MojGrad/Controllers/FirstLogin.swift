//
//  ViewController.swift
//  MojGrad
//
//  Created by Ja on 29/07/2019.
//  Copyright © 2019 Ja. All rights reserved.
//

import UIKit

class FirstLogin: UIViewController {

    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var descriptionView: UITextView!
    @IBOutlet weak var oibButton: UIButton!
    @IBOutlet weak var goToNextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        goToNextButton.setUpButton()
    }
    
    @IBAction func goToRegButton(_ sender: Any) {
        
    }
    

    @IBAction func buttonTapped(_ sender: Any) {
        
    }
}

