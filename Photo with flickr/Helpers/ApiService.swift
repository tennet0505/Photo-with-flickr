//
//  ApiService.swift
//  Photo with flickr
//
//  Created by Oleg Ten on 29/07/2022.
//

import Foundation

protocol ApiProtocol {
    func getPhotos(withRandomGallery: Bool) async throws -> Result<Photo, Error>
    func searchPhotosBy(_ text: String) async throws -> Result<Photo, Error>
}

class ApiService: ApiProtocol {
       
                            
    func getPhotos(withRandomGallery: Bool) async -> Result<Photo, Error> {
        //mock data
        
        let galleryNumber = withRandomGallery ? MockUrl.galleries.randomElement() ?? MockUrl.galleryMain :  MockUrl.galleryMain
        print(galleryNumber)
        let url = URL(string: galleryNumber)
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url!)
            let photos = try JSONDecoder().decode(Photo.self, from: data)
            
            return .success(photos)
        } catch {
            return .failure(error)
        }
    }
    
    func searchPhotosBy(_ text: String) async -> Result<Photo, Error> {
        let searchText = text.replacingOccurrences(of: " ", with: "-")
        let url = URL(string: "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(Constants.APIkey)&format=json&nojsoncallback=1&safe_search=1&text=\(searchText)")
        do {
            let (data, _) = try await URLSession.shared.data(from: url!)
            let photos = try JSONDecoder().decode(Photo.self, from: data)
            return .success(photos)
        } catch {
            return .failure(error)
        }
    }
}
