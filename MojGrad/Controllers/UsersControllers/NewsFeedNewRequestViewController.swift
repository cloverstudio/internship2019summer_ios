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

        if UserDefaults.standard.bool(forKey: Keys.requestSent) {
            let storyboard = UIStoryboard.init(name: "UserRequests", bundle: nil)
            let destination = storyboard.instantiateViewController(withIdentifier: "UserRequests")
            navigationController?.pushViewController(destination, animated: true)
        }
    }
    @IBAction func newRequestButtonTapped(_ sender: UIButton) {
//        performSegue(withIdentifier: "NewRequest", sender: nil)
        let storyboard = UIStoryboard.init(name: "UserRequests", bundle: nil)
        let destination = storyboard.instantiateViewController(withIdentifier: "CreateUserRequest")
        navigationController?.pushViewController(destination, animated: true)
    }
    

}
