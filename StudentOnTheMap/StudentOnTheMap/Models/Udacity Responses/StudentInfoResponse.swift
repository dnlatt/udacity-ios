//
//  StudentInfoResponse.swift
//  StudentOnTheMap
//
//  Created by dnlatt on 4/9/21.
//  Copyright © 2021 dnlatt. All rights reserved.
//

import Foundation

struct StudentProfile: Codable {
    let firstName: String
    let lastName: String
    let nickName: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case nickName = "nickname"
    }
}

