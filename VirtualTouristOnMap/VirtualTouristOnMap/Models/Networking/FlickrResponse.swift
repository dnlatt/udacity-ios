//
//  FlickrResponse.swift
//  VirtualTouristOnMap
//
//  Created by dnlatt on 18/9/21.
//  Copyright © 2021 dnlatt. All rights reserved.
//


struct Flickr:Codable {
    let photos: FlickrPhotos
}

struct FlickrPhotos:Codable {
    let pages: Int
    let perpage: Int
    let total: Int
    let photo: [FlickrPhotoInfo]
}

struct FlickrPhotoInfo:Codable {
    let id: String
    let owner: String
    let secret: String
    let server: String
    let farm: Int
    let title: String
    let ispublic: Int
    let isfriend: Int
    let isfamily: Int
    let url_m: String
    let height_m: Int
    let width_m: Int
}
