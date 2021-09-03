//
//  StudentInformation.swift
//  StudentOnTheMap
//
//  Created by dnlatt on 31/8/21.
//  Copyright © 2021 dnlatt. All rights reserved.
//

import Foundation

struct StudentsLocation: Codable {
    let results: [StudentInformation]
}

struct StudentInformation: Codable {
    let firstName: String
    let lastName: String
    let longitude: Double
    let latitude: Double
    let mapString: String
    let mediaURL: String
    let uniqueKey: String
    let objectId: String?
    let createdAt: String?
    let updatedAt: String?
}


// {"firstName":"Narendar","lastName":"Singh","longitude":23.7274284,"latitude":37.9818899,"mapString":"Athens","mediaURL":"https://www.google.crhome","uniqueKey":"159285065","objectId":"c4cnkqmsfla6gpm9k8ug","createdAt":"2021-08-15T20:34:50.540Z","updatedAt":"2021-08-15T20:34:50.540Z"}
