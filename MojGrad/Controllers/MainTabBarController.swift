//
//  MainTabBarController.swift
//  MojGrad
//
//  Created by Ja on 17/08/2019.
//  Copyright © 2019 Ja. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if UserDefaults.standard.bool(forKey: Keys.rememberMe) {
            if UserDefaults.standard.integer(forKey: Keys.personRoleId) == 2 {
                hideTabBarWithIndex(2)
            } else if UserDefaults.standard.integer(forKey: Keys.personRoleId) == 1 {
            }
        } else if UserDefaults.standard.bool(forKey: Keys.rememberMe) == false{
        }
    }
    
    func hideTabBarWithIndex(_ index: Int) {
            let indexToRemove = index
            if indexToRemove < self.viewControllers?.count ?? 0 {
                var viewControllers = self.viewControllers
                viewControllers?.remove(at: indexToRemove)
                self.viewControllers = viewControllers
            }
        
    }
    
}
