//
//  MainViewModel.swift
//  Photo with flickr
//
//  Created by Oleg Ten on 29/07/2022.
//

import Foundation

class MainViewModel {

private let apiService: ApiProtocol
    var photos: [PhotoElement] = []

init(apiService: ApiProtocol) {
    self.apiService = apiService
}
    
    func getPhotos(complitionSuccess: @escaping ([PhotoElement]) -> (),
                   complitionError: @escaping (Error) -> ())  {
        Task {
            let result: Result<Photo, Error> = try await apiService.getPhotos()
            switch result {
            case .failure(let error):
                complitionError(error)
            case .success(let photos):
                let favIds = UserDefaultsHelper.shared.getFavoritesIDs()
                for id in favIds {
                    photos.photos?.photo.filter({$0.id == id}).first?.isFav = true
                }
                complitionSuccess(photos.photos?.photo ?? [])
            }
        }
    }
    
    func searchPhotosBy(_ text: String,
                        complitionSuccess: @escaping ([PhotoElement]) -> (),
                        complitionError: @escaping (Error) -> ()) {
        Task {
            let result: Result<Photo, Error> = try await apiService.searchPhotosBy(text)
            switch result {
            case .failure(let error):
                complitionError(error)
            case .success(let photos):
                let favIds = UserDefaultsHelper.shared.getFavoritesIDs()
                for id in favIds {
                    photos.photos?.photo.filter({$0.id == id}).first?.isFav = true
                }
                complitionSuccess(photos.photos?.photo ?? [])
            }
        }
    }
}
