//
//  BinarySelector.swift
//  HouseKeeper
//
//  Created by Arjun Chib on 3/30/17.
//  Copyright © 2017 Profectus. All rights reserved.
//

import UIKit

class BinaryCriteriaSelector: CriteriaSelector {
    
    override var value: Int {
        set (newValue) {
            if newValue == 0 {
                radio.selected = false
            } else {
                radio.selected = true
            }
        }
        get {
            if radio.selected {
                return 1
            } else {
                return 0
            }
        }
    }
    
    var radio = RadioButton()
    
    convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: Style.rowHeight, height: Style.rowHeight))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(radio)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
