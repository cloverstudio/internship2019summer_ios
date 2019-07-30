//
//  SetUpGradient.swift
//  MojGrad
//
//  Created by Ja on 29/07/2019.
//  Copyright © 2019 Ja. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func  setUpButton(){
        
        //Gradient for buttons
        let gradient = CAGradientLayer()
        let colorOne = #colorLiteral(red: 0.004859850742, green: 0.09608627111, blue: 0.5749928951, alpha: 1)
        let colorTwo = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        gradient.frame = bounds
        gradient.colors = [colorOne, colorTwo]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 0.0, y: 0.0)
        
        layer.insertSublayer(gradient, at: 0)
        
        //Corner radius of buttons
        self.layer.cornerRadius = 12.5
    }
}
