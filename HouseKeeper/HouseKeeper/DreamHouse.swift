//
//  DreamHouse.swift
//  HouseKeeper
//
//  Created by Arjun Chib on 4/1/17.
//  Copyright © 2017 Profectus. All rights reserved.
//

import Foundation

class DreamHouse: House {
    
    static let sharedInstance = DreamHouse()
    
    private init() {
        super.init(hid: 0, address: "Dream House")
    }
    
    override func calculateRank() {
        rank = 0.0
    }
}
