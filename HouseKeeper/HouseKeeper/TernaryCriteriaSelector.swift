//
//  TernaryCriteriaSelector.swift
//  HouseKeeper
//
//  Created by Arjun Chib on 3/31/17.
//  Copyright © 2017 Profectus. All rights reserved.
//

import UIKit
import SnapKit
import FontAwesome_swift

class TernaryCriteriaSelector: CriteriaSelector {
    
    override var value: Int {
        set (newValue) {
            radioN.selected = false
            radioZ.selected = false
            radioP.selected = false
            if newValue == -1 {
                radioN.selected = true
            } else if newValue == 0 {
                radioZ.selected = true
            } else if newValue == 1 {
                radioP.selected = true
            }
        }
        get {
            if radioN.selected {
                return -1
            } else if radioP.selected {
                return 1
            } else {
                return 0
            }
        }
    }
    
    let radioN = RadioButton()
    let radioZ = RadioButton()
    let radioP = RadioButton()
    
    convenience init() {
        let width = Style.rowHeight * 3
        self.init(frame: CGRect(x: 0, y: 0, width: width, height: Style.rowHeight))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        radioN.setIcon(name: .minus, color: Style.redColor)
        radioP.setIcon(name: .plus, color: Style.redColor)
        
        addSubview(radioN)
        addSubview(radioZ)
        addSubview(radioP)
        
        radioN.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.size.equalTo(Style.rowHeight)
        }
        
        radioZ.snp.makeConstraints { (make) in
            make.left.equalTo(radioN.snp.right)
            make.size.equalTo(Style.rowHeight)
        }
        
        radioP.snp.makeConstraints { (make) in
            make.left.equalTo(radioZ.snp.right)
            make.size.equalTo(Style.rowHeight)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        radioN.selected = false
        radioZ.selected = false
        radioP.selected = false
        super.touchesBegan(touches, with: event)
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
