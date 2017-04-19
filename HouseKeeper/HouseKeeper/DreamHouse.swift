//
//  DreamHouse.swift
//  HouseKeeper
//
//  Created by Arjun Chib on 4/1/17.
//  Copyright © 2017 Profectus. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class DreamHouse: House {
    
    static let shared = DreamHouse()
    
    private override init() {
        super.init()
        requestDreamHouse()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func calculateRank() {
        rank = 0.0
    }
    
    func requestDreamHouse() {
        if (Networking.token == "") {
            return
        }
        let headers = generateHeaders()
        Alamofire.request(Networking.baseURL + "/getDreamHouse", method: .get, headers: headers)
            .responseString { response in
                if (response.error != nil) {
                    print("Get dream house failed: " + (response.error?.localizedDescription)!)
                    return
                }
                let success = validate(statusCode: (response.response?.statusCode)!)
                if success {
                    let json = JSON(response.data!)
                    var dreamHouse = json["dreamHouse"].dictionaryValue
                    self.hid = (dreamHouse["hid"]?.intValue)!
                    self.address = (dreamHouse["address"]?.stringValue)!
                    MyHouses.shared.syncCriteria(for: self, completion: { (success) in
                        //nothing
                    })
                } else {
                    print("Get dream house failed: " + response.result.value!)
                }
        }
    }
}
