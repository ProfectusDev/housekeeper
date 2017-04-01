//
//  Criteria.swift
//  Open House
//
//  Created by Arjun Chib on 11/11/16.
//  Copyright © 2016 Profectus. All rights reserved.
//


// The criterion class 
import Foundation
import SwiftyJSON

enum Category: String {
    case location
    case price
    case amenities
    case interior
    case exterior
    case other

    static let allValues = [location, price, amenities, interior, exterior, other]
}

class Criterion: CustomStringConvertible {
    var id: Int
    var name = ""
    var category = Category.other
    var value = 0

    public var description: String { return name }

    init(id: Int) {
        self.id = id
    }

    static func decodeJSON(data: Dictionary<String, JSON>) -> Criterion {
        let id = data["id"]?.intValue
        let name = data["name"]?.stringValue
        let category = data["category"]?.stringValue
//        let type = data["type"]?.intValue
        let value = data["value"]?.intValue

        let criterion = Criterion(id: id!)
        criterion.name = name!
        criterion.category = Category(rawValue: category!)!
        criterion.value = value!

        return criterion
    }
}
