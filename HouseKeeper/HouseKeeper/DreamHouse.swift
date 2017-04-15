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
    
    private init() {
        super.init(hid: 0, address: "Dream House")
        requestDreamHouse()
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
                    print(self.hid)
                } else {
                    print("Get dream house failed: " + response.result.value!)
                }
        }
    }
}
