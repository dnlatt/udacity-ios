//
//  FlickrClient.swift
//  VirtualTouristOnMap
//
//  Created by dnlatt on 18/9/21.
//  Copyright © 2021 dnlatt. All rights reserved.
//

import Foundation
import UIKit

class FlickrClient {
   
    // MARK : Properties
    static let apiKey = "59489c25333eccab5c1b25e522870585"
    
    enum Endpoints {
        
        static let base = "https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(apiKey)&format=json&nojsoncallback=1&extras=url_m"

        case searchPhotos(Double, Double, Int)
        
        var stringValue: String {
            switch(self) {
            case .searchPhotos(let latitude, let longitude, let page):

                return Endpoints.base + "&lat=\(latitude)&lon=\(longitude)&radius=16&per_page=18&page=\(page)"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    // MARK : Get All Flickrs Photos
    
    class func getAllFlickrsPhotos(completion: @escaping(Flickr?, Error?, Bool)-> Void, url:URL){
            let request = URLRequest(url: url)
            let session = URLSession.shared
            let task = session.dataTask(with: request) { data, response, error in
                guard let data = data else {
                    print(error?.localizedDescription ?? "")
                    completion(nil,error, false)
                    return
                }
                do {
    
                    let decoder = JSONDecoder()
                    let responseObject = try decoder.decode(Flickr.self, from: data)
                    completion(responseObject.self, nil, true)

                } catch{
                    
                    print(error)
                    completion(nil,error, false)

                }
            }
            task.resume()
        }
}
