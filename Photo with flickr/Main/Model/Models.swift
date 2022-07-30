//
//  Models.swift
//  Photo with flickr
//
//  Created by Oleg Ten on 29/07/2022.
//

import Foundation

// MARK: - Photo
class Photo: Codable {
    var photos: Photos?
    var stat: String
    
    init(photos: Photos?, stat: String) {
        self.photos = photos
        self.stat = stat
    }
}

// MARK: - Photos
class Photos: Codable {
    var page, pages, perpage, total: Int
    var photo: [PhotoElement]
    
    init(page: Int, pages: Int, perpage: Int, total: Int, photo: [PhotoElement]) {
        self.page = page
        self.pages = pages
        self.perpage = perpage
        self.total = total
        self.photo = photo
    }
}

// MARK: - PhotoElement
class PhotoElement: Codable {
    var id: String
    var owner: String
    var secret: String
    var server: String
    var farm: Int
    var title: String
    var isFav: Bool?
    
    var urlImage: URL? {
        let stringURL = "http://farm\(farm).static.flickr.com/\(server)/\(id)_\(secret).jpg"
        let url: URL = URL(string: stringURL)!
        return url
    }
    
    init(id: String, owner: String, secret: String, server: String, farm: Int, title: String, isFav: Bool?, urlImage: URL?) {
        self.id = id
        self.owner = owner
        self.secret = secret
        self.server = server
        self.farm = farm
        self.title = title
        self.isFav = isFav
    }
}
