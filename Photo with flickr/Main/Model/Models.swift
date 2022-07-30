//
//  Models.swift
//  Photo with flickr
//
//  Created by Oleg Ten on 29/07/2022.
//

import Foundation

// MARK: - Photo
struct Photo: Codable {
    var photos: Photos?
    var stat: String
}

// MARK: - Photos
struct Photos: Codable {
    var page, pages, perpage, total: Int
    var photo: [PhotoElement]
}

// MARK: - PhotoElement
struct PhotoElement: Codable {
    var id: String
    var owner: String
    var secret: String
    var server: String
    var farm: Int
    var title: String
    
    var urlImage: URL {
        let stringURL = "http://farm\(farm).static.flickr.com/\(server)/\(id)_\(secret).jpg"
        let url: URL = URL(string: stringURL)!
        return url
    }
}
