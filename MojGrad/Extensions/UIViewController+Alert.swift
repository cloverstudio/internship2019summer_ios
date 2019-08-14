//
//  UIViewController+Alert.swift
//  MojGrad
//
//  Created by Ja on 12/08/2019.
//  Copyright © 2019 Ja. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlert(withTitle title: String, withMessage message: Any) {
        let alert = UIAlertController(title: title, message: message as? String, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { action in
        })
//        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: { action in
//        })
        alert.addAction(ok)
        //alert.addAction(cancel)
        DispatchQueue.main.async(execute: {
            self.present(alert, animated: true)
        })
    }
}
