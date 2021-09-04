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
    
    init(_ dictionary: [String: AnyObject]) {
        self.firstName = dictionary["firstName"] as? String ?? ""
        self.lastName = dictionary["lastName"] as? String ?? ""
        self.longitude = dictionary["longitude"] as? Double ?? 0.0
        self.latitude = dictionary["latitude"] as? Double ?? 0.0
        self.mapString = dictionary["mapString"] as? String ?? ""
        self.mediaURL = dictionary["mediaURL"] as? String ?? ""
        self.uniqueKey = dictionary["uniqueKey"] as? String ?? ""
        self.objectId = dictionary["objectId"] as? String ?? ""
        self.createdAt = dictionary["createdAt"] as? String ?? ""
        self.updatedAt = dictionary["updatedAt"] as? String ?? ""
    }
}


