//
//  Criteria.swift
//  Open House
//
//  Created by Arjun Chib on 11/11/16.
//  Copyright © 2016 Profectus. All rights reserved.
//

import Foundation
import SwiftyJSON

enum Category: String {
    case location
    case price
    case amenities
    case interior
    case extrior
    case other
}

class Criterion {
    var name: String
    var category: Category
    var value: Int
    
    init(name: String) {
        self.name = name
        category = .other
        value = 0
    }
    
    static func decodeJSON(data: Dictionary<String, JSON>) -> Criterion {
        let name = data["name"]?.stringValue
        let category = data["category"]?.stringValue
//        let type = data["type"]?.intValue
        let value = data["value"]?.intValue
        let criterion = Criterion(name: name!)
        criterion.category = Category(rawValue: category!)!
        criterion.value = value!
        return criterion
    }
}
