//
//  UITextView+SetBottomBorder.swift
//  MojGrad
//
//  Created by Ja on 19/08/2019.
//  Copyright © 2019 Ja. All rights reserved.
//

import Foundation
import UIKit

extension UITextView {
    
    func addBottomBorderWithColor(color: UIColor, height: CGFloat) {
        let border = UIView()
        border.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        border.frame = CGRect(x: self.frame.origin.x,
                              y: self.frame.origin.y+self.frame.height-height, width: self.frame.width, height: height)
        border.backgroundColor = color
        self.superview!.insertSubview(border, aboveSubview: self)
    }
}
