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

enum DataType: String {
    case binary
    case ternary
    
    static let allValues = [binary, ternary]
}


class Criterion: NSObject, NSCoding {
    var id = 0
    var name = ""
    var category = Category.other
    var value = 0
    var type = DataType.binary
    var isDream = false


    override public var description: String { return "\(id): \(name)" }

    init(id: Int) {
        self.id = id
    }
    
    required init(coder aDecoder: NSCoder) {
        id = aDecoder.decodeInteger(forKey: "id")
        name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        if aDecoder.decodeObject(forKey: "category") != nil {
            category = Category(rawValue: aDecoder.decodeObject(forKey: "category") as! String) ?? .other
        }
        value = aDecoder.decodeInteger(forKey: "value")
        if aDecoder.decodeObject(forKey: "type") != nil {
            type = DataType(rawValue: aDecoder.decodeObject(forKey: "type") as! String) ?? .binary
        }
        isDream = aDecoder.decodeBool(forKey: "dream")
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(category.rawValue, forKey: "category")
        aCoder.encode(value, forKey: "value")
        aCoder.encode(type.rawValue, forKey: "type")
        aCoder.encode(isDream, forKey: "dream")
    }

    static func decodeJSON(data: Dictionary<String, JSON>) -> Criterion {
        let id = data["id"]?.intValue
        let name = data["name"]?.stringValue
        let category = data["category"]?.stringValue
        let type = data["data type"]?.stringValue
        let value = data["value"]?.intValue
        let isDream = data["isDream"]?.intValue

        let criterion = Criterion(id: id!)
        criterion.name = name!
        criterion.category = Category(rawValue: category!)!
        criterion.value = value!
        criterion.type = DataType(rawValue: type!)!
        criterion.isDream = isDream != 0

        return criterion
    }
}
