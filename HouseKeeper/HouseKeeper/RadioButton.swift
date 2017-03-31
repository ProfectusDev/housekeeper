//
//  RadioButton.swift
//  HouseKeeper
//
//  Created by Arjun Chib on 3/30/17.
//  Copyright © 2017 Profectus. All rights reserved.
//

import UIKit
import FontAwesome_swift

class RadioButton: UIView {
    
    let outerCircleLayer = CAShapeLayer()
    let innerCircleLayer = CAShapeLayer()
    
    let iconView = UIImageView()
    var iconName: FontAwesome?
    let iconSize = CGSize(width: 15, height: 15)
    
    var selected: Bool = false {
        didSet {
            setSelected(selected: selected)
        }
    }
    var color = Style.redColor
    
    convenience init() {
        let frame = CGRect(x: 0.0, y: 0.0, width: Style.rowHeight, height: Style.rowHeight)
        self.init(frame: frame)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let outerDiameter = CGFloat(30.0)
        let innerDiameter = CGFloat(27.0)
        
        let outerFrame = CGRect(
            x: (frame.size.width - outerDiameter) / 4,
            y: (frame.size.height - outerDiameter) / 4,
            width: outerDiameter,
            height: outerDiameter
        )
        outerCircleLayer.frame = outerFrame
        outerCircleLayer.path = UIBezierPath(roundedRect: outerFrame, cornerRadius: outerDiameter / 2).cgPath
        outerCircleLayer.lineWidth = 1.0
        outerCircleLayer.fillColor = UIColor.clear.cgColor
        outerCircleLayer.strokeColor = color.cgColor
        
        let innerFrame = CGRect(
            x: (frame.size.width - innerDiameter) / 4,
            y: (frame.size.height - innerDiameter) / 4,
            width: innerDiameter,
            height: innerDiameter
        )
        innerCircleLayer.frame = innerFrame
        innerCircleLayer.path = UIBezierPath(roundedRect: innerFrame, cornerRadius: innerDiameter / 2).cgPath
        innerCircleLayer.lineWidth = 0.0
        innerCircleLayer.fillColor = UIColor.clear.cgColor
        
        layer.addSublayer(outerCircleLayer)
        layer.addSublayer(innerCircleLayer)
        
        addSubview(iconView)
        
        iconView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        selected = !selected
    }
    
    func setSelected(selected: Bool) {
        if selected {
            innerCircleLayer.fillColor = color.cgColor
            changeIconColor(color: Style.whiteColor)
        } else {
            innerCircleLayer.fillColor = UIColor.clear.cgColor

            changeIconColor(color: Style.redColor)
        }
    }
    
    func setIcon(name: FontAwesome, color: UIColor) {
        iconName = name
        iconView.image = UIImage.fontAwesomeIcon(name: name, textColor: color, size: iconSize)
    }
    
    func changeIconColor(color: UIColor) {
        if iconName != nil {
            iconView.image = UIImage.fontAwesomeIcon(name: iconName!, textColor: color, size: iconSize)
        }
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
