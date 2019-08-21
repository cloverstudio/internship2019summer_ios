//
//  NewsFeedNewRequestViewController.swift
//  MojGrad
//
//  Created by Ja on 19/08/2019.
//  Copyright © 2019 Ja. All rights reserved.
//

import UIKit

class AddNewUserRequestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func newRequestButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "NewRequest", sender: nil)
    }
    

}
