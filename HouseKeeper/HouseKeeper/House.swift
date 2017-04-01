//
//  House.swift
//  Open House
//
//  Created by Arjun Chib on 11/11/16.
//  Copyright © 2016 Profectus. All rights reserved.
//

import UIKit

// House class
class House {
    var hid: Int
    var address: String
    var criteria: [[Criterion]] = Array(repeatElement([Criterion](), count: Category.allValues.count)) {
        didSet {
            calculateRank()
        }
    }
    var rank = 0.0
    var image: UIImage

    public var description: String { return "\(address)" }

    init(hid: Int, address: String) {
        self.address = address
        self.hid = hid
        image = UIImage()
    }
    
    func calculateRank() {
        rank = 0.0
        for section in criteria {
            for criterion in section {
                rank += Double(criterion.value)
            }
        }
    }
}
