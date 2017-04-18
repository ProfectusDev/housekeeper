//
//  House.swift
//  Open House
//
//  Created by Arjun Chib on 11/11/16.
//  Copyright © 2016 Profectus. All rights reserved.
//

import UIKit

// House class
class House: NSObject, NSCoding {
    
    var hid = 0
    var address = ""
    var rank = 0.0
    var image = UIImage()
    var criteria: [[Criterion]] = Array(repeatElement([Criterion](), count: Category.allValues.count)) {
        didSet {
            calculateRank()
        }
    }

    override public var description: String { return "\(hid): \(address)" }
    
    override init() {}

    init(hid: Int, address: String) {
        self.address = address
        self.hid = hid
    }
    
    required init(coder aDecoder: NSCoder) {
        hid = aDecoder.decodeInteger(forKey: "hid") 
        address = aDecoder.decodeObject(forKey: "address") as? String ?? ""
        rank = aDecoder.decodeDouble(forKey: "rank")
        image = aDecoder.decodeObject(forKey: "image") as? UIImage ?? UIImage()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(hid, forKey: "hid")
        aCoder.encode(address, forKey: "address")
        aCoder.encode(rank, forKey: "rank")
        aCoder.encode(image, forKey: "image")
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
