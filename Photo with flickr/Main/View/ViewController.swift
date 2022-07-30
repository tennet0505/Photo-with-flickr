//
//  ViewController.swift
//  Photo with flickr
//
//  Created by Oleg Ten on 29/07/2022.
//

import UIKit

class ViewController: UIViewController {

    var viewModel: MainViewModel!
    var apiService: ApiService!
    var photos: [PhotoElement] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewModel()
        getPhotos()
//        searchPhotosBy("gor")
    }
    
    func setupViewModel() {
        apiService = ApiService()
        viewModel = MainViewModel(apiService: apiService)
    }
    
    func getPhotos() {
        viewModel.getPhotos(
            complitionSuccess: { photos in
                self.photos.removeAll()
                self.photos = photos
            }, complitionError: { error in
                print(error)
            })
    }
    
    func searchPhotosBy(_ text: String)  {
        viewModel.searchPhotosBy(text,
                                 complitionSuccess: { photos in
            self.photos.removeAll()
            self.photos = photos
        }, complitionError: { error in
            print(error)
        })
    }
}

