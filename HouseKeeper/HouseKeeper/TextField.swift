//
//  TextField.swift
//  HouseKeeper
//
//  Created by Arjun Chib on 1/26/17.
//  Copyright © 2017 Profectus. All rights reserved.
//

import UIKit

// Class for the text field box
class TextField: UITextField {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    override func draw(_ rect: CGRect) {
        layer.borderWidth = 2.0
        layer.cornerRadius = rect.size.height / 2
        layer.masksToBounds = true
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return customRect(forBounds: bounds)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return customRect(forBounds: bounds)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return customRect(forBounds: bounds)
    }

    func customRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 15,
                      y: bounds.origin.y,
                      width: bounds.size.width - 20,
                      height: bounds.size.height)
    }
}
