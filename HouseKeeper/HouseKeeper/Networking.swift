//
//  Constant.swift
//  HouseKeeper
//
//  Created by Arjun Chib on 1/27/17.
//  Copyright © 2017 Profectus. All rights reserved.
//

import UIKit
import Alamofire

// Helper functions to perform networking calls
struct Networking {
    static let baseURL = "http://45.55.183.86:8081/api"
    static var token = ""
}

func validate(statusCode: Int) -> Bool {
    return statusCode >= 200 && statusCode < 300
}

func generateHeaders() -> HTTPHeaders {
    if Networking.token == "" {
        return [:]
    } else {
        return ["Authorization": "Bearer " + Networking.token]
    }
}
