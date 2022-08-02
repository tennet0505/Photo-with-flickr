//
//  ApiService.swift
//  Photo with flickr
//
//  Created by Oleg Ten on 29/07/2022.
//

import Foundation

protocol ApiProtocol {
    func make(apiRequest: ApiRequest) async -> Result<Photo, Error>
}

enum ApiRequest {
    case getPhoto(withRandomGallery: Bool)
    case searchPhotosBy(_ text: String)
}

class ApiService: ApiProtocol {
    
    func make(apiRequest: ApiRequest) async -> Result<Photo, Error>  {
        let url: URL?
        
        switch apiRequest {
            
        case .getPhoto(let withRandomGallery):
            let galleryNumber = withRandomGallery ? MockUrl.galleries.randomElement() ?? MockUrl.galleryMain :  MockUrl.galleryMain
            url = URL(string: galleryNumber)
        case .searchPhotosBy(let text):
            let searchText = text.replacingOccurrences(of: " ", with: "-")
            url = URL(string: "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(Constants.APIkey)&format=json&nojsoncallback=1&safe_search=1&text=\(searchText)")
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url!)
            let photos = try JSONDecoder().decode(Photo.self, from: data)
            
            return .success(photos)
        } catch {
            return .failure(error)
        }
    }
}
