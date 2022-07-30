//
//  ApiService.swift
//  Photo with flickr
//
//  Created by Oleg Ten on 29/07/2022.
//

import Foundation

protocol ApiProtocol {
    func getPhotos() async throws -> Result<Photo, Error>
    func searchPhotosBy(_ text: String) async throws -> Result<Photo, Error>
}

class ApiService: ApiProtocol {
    
    private let url = URL(string:"https://www.flickr.com/services/rest/?method=flickr.galleries.getPhotos&api_key=4c78bf3ac2290a4de8f56802bc1c41ac&gallery_id=72157720505970591&format=json&nojsoncallback=1&auth_token=72157720852060992-8ae28a7627974352&api_sig=3939b5787bd593a050736588df1af387")
                            
    func getPhotos() async -> Result<Photo, Error> {
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
