//
//  MainViewModel.swift
//  Photo with flickr
//
//  Created by Oleg Ten on 29/07/2022.
//

import Foundation

protocol MainViewModeldelegate: AnyObject {
    func didStartRequest()
    func didFinishLoading(photos: [PhotoElement])
    func didFinishWith(Error: Error)
}

class MainViewModel {

    private let apiService: ApiProtocol
    var photos: [PhotoElement] = []
    weak var mainViewModeldelegate: MainViewModeldelegate?

init(apiService: ApiProtocol) {
    self.apiService = apiService
}
    
    func getPhotos(withRandomGallery: Bool) {
       
        Task {
            mainViewModeldelegate?.didStartRequest()
            let result: Result<Photo, Error> = try await apiService.getPhotos(withRandomGallery: withRandomGallery)
            switch result {
            case .failure(let error):
                mainViewModeldelegate?.didFinishWith(Error: error)
            case .success(let photos):
                let favIds = UserDefaultsHelper.shared.getFavoritesIDs()
                for id in favIds {
                    photos.photos?.photo.filter({$0.id == id}).first?.isFav = true
                }
                mainViewModeldelegate?.didFinishLoading(photos: photos.photos?.photo ?? [])
            }
        }
    }
    
    func searchPhotosBy(_ text: String) {
        Task {
            mainViewModeldelegate?.didStartRequest()

            let result: Result<Photo, Error> = try await apiService.searchPhotosBy(text)
            switch result {
            case .failure(let error):
                mainViewModeldelegate?.didFinishWith(Error: error)
            case .success(let photos):
                let favIds = UserDefaultsHelper.shared.getFavoritesIDs()
                for id in favIds {
                    photos.photos?.photo.filter({$0.id == id}).first?.isFav = true
                }
                mainViewModeldelegate?.didFinishLoading(photos: photos.photos?.photo ?? [])
            }
        }
    }
}
