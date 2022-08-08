//
//  MainViewModel.swift
//  Photo with flickr
//
//  Created by Oleg Ten on 29/07/2022.
//

import Foundation

class MainViewModel {
    
    private let apiService: ApiProtocol
    @Published var results: Result<Photo, Error>?
    
    init(apiService: ApiProtocol) {
        self.apiService = apiService
    }
    
    func make(apiRequest: ApiRequest) {
        Task {
            let result: Result<Photo, Error>
            switch apiRequest {
            case .getPhoto(let withRandomGallery):
                result = await apiService.make(apiRequest: .getPhoto(withRandomGallery: withRandomGallery))
            case .searchPhotosBy(let text):
                result = await apiService.make(apiRequest: .searchPhotosBy(text))
            }
            
            switch result {
            case .failure(let error):
                self.results = .failure(error)
            case .success(let photos):
                let favIds = UserDefaultsHelper.shared.getFavoritesIDs()
                for id in favIds {
                    photos.photos?.photo.filter({$0.id == id}).first?.isFav = true
                }
                self.results = .success(photos)
            }
        }
    }
}
