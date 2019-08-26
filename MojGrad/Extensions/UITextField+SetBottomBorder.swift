//
//  SetBottomBorder.swift
//  MojGrad
//
//  Created by Ja on 01/08/2019.
//  Copyright © 2019 Ja. All rights reserved.
//

import Foundation
import UIKit
// TODO: NAME THE EXTENSION ACCORDING TO WHAT THEY DO e.g.: UITextField+setBottomBorder
extension UITextField {
    
    func setBottomBorder() {
        
        self.borderStyle = UITextField.BorderStyle.none
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = UIColor.lightGray.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
        
    }
}
