//
//  MainViewModel.swift
//  Photo with flickr
//
//  Created by Oleg Ten on 29/07/2022.
//

import Foundation

protocol MainViewModelDelegate: AnyObject {
    func didStartRequest()
    func didFinishLoading(photos: [PhotoElement])
    func didFinishWith(Error: Error)
}

class MainViewModel {
    
    private let apiService: ApiProtocol
    var photos: [PhotoElement] = []
    weak var mainViewModeldelegate: MainViewModelDelegate?
    
    init(apiService: ApiProtocol) {
        self.apiService = apiService
    }
    
    func make(apiRequest: ApiRequest) {
        Task {
            mainViewModeldelegate?.didStartRequest()
            let result: Result<Photo, Error>
            switch apiRequest {
            case .getPhoto(let withRandomGallery):
                result = await apiService.make(apiRequest: .getPhoto(withRandomGallery: withRandomGallery))
            case .searchPhotosBy(let text):
                result = await apiService.make(apiRequest: .searchPhotosBy(text))
            }
            
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
