//
//  Charts.swift
//  HouseKeeper
//
//  Created by Arjun Chib on 4/19/17.
//  Copyright © 2017 Profectus. All rights reserved.
//

import UIKit

class Chart: UIView {
    
    let numBars = Category.allValues.count
    var bars = [UIView]()
    var titleViews = [UILabel]()
    let colors = [Style.redColor, Style.orangeColor, Style.yellowColor, Style.greenColor, Style.blueColor, Style.pinkColor]
    let titles = ["L", "P", "A", "I", "E", "O"]
    let padding = 5.0
    
    init() {
        super.init(frame: CGRect.zero)
        backgroundColor = Style.whiteColor
        for index in 0..<numBars {
            let bar = UIView()
            bar.backgroundColor = colors[index]
            bar.layer.cornerRadius = 5.0
            
            let titleView = UILabel()
            titleView.text = titles[index]
            titleView.textColor = colors[index]
            titleView.textAlignment = .center
            titleView.font = UIFont.boldSystemFont(ofSize: 14.0)
            
            let width = (Double(frame.width) - padding * Double(numBars - 1)) / Double(numBars)
            let height = 15.0
            let x = Double(index) * (width + padding)
            let y = Double(frame.height) - height
            
            titleView.frame = CGRect(x: x, y: y, width: width, height: height)
            
            addSubview(bar)
            addSubview(titleView)
            
            bars.append(bar)
            titleViews.append(titleView)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        for (index, titleView) in titleViews.enumerated() {
            let width = (Double(frame.width) - padding * Double(numBars - 1)) / Double(numBars)
            let height = 15.0
            let x = Double(index) * (width + padding)
            let y = Double(frame.height) - height - padding
            titleView.frame = CGRect(x: x, y: y, width: width, height: height)
        }
    }
    
    func updateValue(value: Double, for index: Int) {
        let width = (Double(frame.width) - padding * Double(numBars - 1)) / Double(numBars)
        let height = Double(frame.height) * value
        let x = Double(index) * (width + padding)
        let y = Double(frame.height) - height
        if frame != CGRect.zero {
            if self.bars[index].frame == CGRect.zero {
                self.bars[index].frame = CGRect(x: x, y: Double(frame.height), width: width, height: 0)
            }
            UIView.animate(withDuration: 0.3) {
                self.bars[index].frame = CGRect(x: x, y: y, width: width, height: height)
                if value > 0 {
                    self.titleViews[index].textColor = Style.whiteColor
                } else {
                    self.titleViews[index].textColor = self.colors[index]
                }
            }
        }
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
