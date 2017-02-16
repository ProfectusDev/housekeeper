//
//  House.swift
//  Open House
//
//  Created by Arjun Chib on 11/11/16.
//  Copyright © 2016 Profectus. All rights reserved.
//

import UIKit

class House {
    var address: String
    var location: String
    var image: UIImage
    var beds: Int
    var baths: Int
    var rating: Float
    var categories: [Category]
    
    init(address: String) {
        self.address = address
        location = ""
        image = UIImage()
        beds = 0
        baths = 0
        rating = 0
        categories = []
    }
    
}
