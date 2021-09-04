//
//  LoginResponse.swift
//  StudentOnTheMap
//
//  Created by dnlatt on 31/8/21.
//  Copyright © 2021 dnlatt. All rights reserved.
//

import Foundation

struct LoginResponse: Codable {
    let account: Account
    let session: Session
}

struct Account: Codable {
    let registered: Bool
    let key: String
}


