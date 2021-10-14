//
//  MatchAPI.swift
//  LattSports
//
//  Created by dnlatt on 1/10/21.
//  Copyright © 2021 dnlatt. All rights reserved.
//

import Foundation

class MatchAPI {
    // Properties
    static let apiKey = "7dedb6ab77e14c4ded17937896128b3c"
    static let host = "v3.football.api-sports.io"
    
    enum Endpoints {
        
        static let base = "https://v3.football.api-sports.io/"
        
        
        case getStandings
        case getFixtures
        case getResults
        
        var stringValue: String {
            switch(self) {
                case .getStandings:
                    return Endpoints.base+"standings?league=39&season=2021"
                
                case .getFixtures:
                return "https://raw.githubusercontent.com/dnlatt/test2/master/fixtureResponse.json"
                
                case .getResults:
                return "https://raw.githubusercontent.com/dnlatt/test2/master/matchResult.json"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    
    // session to be used to make the API call
    let session: URLSession
    
    init(urlSession: URLSession = URLSession.shared) {
      self.session = urlSession
    }

    func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionTask {
        
        var request = URLRequest(url: url)
        
        request.addValue(MatchAPI.apiKey, forHTTPHeaderField: "x-rapidapi-key")
        request.addValue(MatchAPI.host, forHTTPHeaderField: "x-rapidapi-host")

        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard var data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            let decoder = JSONDecoder()
            do {
         
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
    
            
        }
        task.resume()
        return task
    }
    
    static let shared = MatchAPI()
}
