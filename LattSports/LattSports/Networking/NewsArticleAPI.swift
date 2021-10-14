//
//  NewsArticleAPI.swift
//  LattSports
//
//  Created by dnlatt on 28/9/21.
//  Copyright © 2021 dnlatt. All rights reserved.
//

import Foundation



class NewsAPIClient {
    // Properties
    static let apiKey = "064e4690770a4bda8b399ac2a98bcc04"
    
    enum Endpoints {
        
        static let base = "https://newsapi.org/v2/"
        static let apiString = "&apiKey=\(apiKey)"
        
        case getAllNews
        
        var stringValue: String {
            switch(self) {
                case .getAllNews:
                    return Endpoints.base+"top-headlines?country=gb&category=sports"
            }
        }
        
        var url: URL {
            return URL(string: stringValue+Endpoints.apiString)!
        }
    }
    
    
    // session to be used to make the API call
    let session: URLSession
    
    init(urlSession: URLSession = URLSession.shared) {
      self.session = urlSession
    }
    
    // get user profile from backend
    func getData(completion: @escaping (ArticlesResponses?, Error?, Bool) -> Void, url: URL) {
        
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request) { data, response, error in
    
            guard let data = data else {
                
                completion(nil,error, false)
                //print("Getting Data Error \(error)")
                return
            }
            do {
                let decoder = JSONDecoder()
                let responseObject = try decoder.decode(ArticlesResponses.self, from: data)
                completion(responseObject.self, nil, true)
                //print("Getting Data News Data \(responseObject)")

            } catch{
                completion(nil,error, false)
                //print("Fetch Error \(error)")
            }
        }
        task.resume()
        
    }
    
    static let shared = NewsAPIClient()
}
