//
//  Constant.swift
//  HouseKeeper
//
//  Created by Arjun Chib on 1/27/17.
//  Copyright © 2017 Profectus. All rights reserved.
//

import UIKit
import Alamofire

struct Networking {
    static let baseURL = "http://45.55.183.86:8081/api"
    static let secret = "SFdhi9memesf3U3v5NqvBD9o35m0iM3e69420lYE1xxcv"
    static var token = ""
    static var userID = 0
}

func validate(statusCode: Int) -> Bool {
    return statusCode >= 200 && statusCode < 300
}
