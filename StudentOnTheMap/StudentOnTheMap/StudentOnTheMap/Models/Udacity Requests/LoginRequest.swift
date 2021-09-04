//
//  UdacityLogin.swift
//  StudentOnTheMap
//
//  Created by dnlatt on 31/8/21.
//  Copyright © 2021 dnlatt. All rights reserved.
//

import Foundation

struct LoginRequest: Codable {
    let udacity: Udactiy
}

struct Udactiy: Codable {
    let username: String
    let password: String
}
