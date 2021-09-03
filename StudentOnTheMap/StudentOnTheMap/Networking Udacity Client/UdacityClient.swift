//
//  UdacityClient.swift
//  StudentOnTheMap
//
//  Created by dnlatt on 31/8/21.
//  Copyright © 2021 dnlatt. All rights reserved.
//

import Foundation

class UdacityClient {
    
    struct Auth {
        static var sessionId: String? = nil
        static var key = ""
        static var objectId = ""
    }
    
    // MARK : Properties
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1"

        
        case login
        case logOut
        case studentLocation
        case addStudentLocation
        case signUp
        
        var stringValue: String {
            switch self {
                case .login:
                    return Endpoints.base + "/session"
                case .logOut:
                    return Endpoints.base + "/session"
                case .studentLocation:
                    return Endpoints.base + "/StudentLocation?limit=100&order=-updatedAt"
                case .addStudentLocation:
                    return Endpoints.base + "/StudentLocation"
                case .signUp:
                    return "https://auth.udacity.com/sign-up"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    //MARK : Login
    
    class func login(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        let udactiyStudent = Udactiy(username: username, password: password)
        let body = LoginRequest(udacity: udactiyStudent)
        
        NetworkingHelpers.taskForPOSTRequest(url: Endpoints.login.url, responseType: LoginResponse.self, body: body, apiPostType: "Udacity", completion: { (response, error) in
            if let response = response {
                Auth.sessionId = response.session.id
                Auth.key = response.account.key
                completion(true, nil)
            } else {
                completion(false, nil)
            }
        })
        
    }
    
    // MARK : Log Out
    
    class func logOut(completion: @escaping () -> Void)
    {
        var request = URLRequest(url: Endpoints.logOut.url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
          if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
          request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
          if error != nil { // Handle error…
              return
          }
          let range = 5..<data!.count
            _ = data?.subdata(in: range) /* subset response data! */
          
            Auth.sessionId = ""
            completion()
        }
        task.resume()
        
    }
    
    // MARK : Get All Student Locations
    
    class func getAllStudentsLocations (completion: @escaping ([StudentInformation]?, Error?) -> Void) {
        NetworkingHelpers.taskForGETRequest(url: Endpoints.studentLocation.url, responseType: StudentsLocation.self) { (response, error) in
            if let response = response {
                completion(response.results, nil)
            } else {
                completion([], error)
            }
        }
    }
    
    // MARK : Add Student Location
    
    class func addStudentLocation(information: StudentInformation, completion: @escaping (Bool, Error?) -> Void) {
        let body = information
        
        NetworkingHelpers.taskForPOSTRequest(url: Endpoints.addStudentLocation.url, responseType: PostResponse.self, body: body, apiPostType: "Parse" ) { (response, error) in
            if let response = response, response.createdAt != nil {

                Auth.objectId = response.objectId ?? ""
                completion(true, nil)
                
            } else {
                completion(false, error)
            }
            
        }
    }
    
}
