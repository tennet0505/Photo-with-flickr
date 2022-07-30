//
//  Photo_with_flickrTests.swift
//  Photo with flickrTests
//
//  Created by Oleg Ten on 29/07/2022.
//

import XCTest
@testable import Photo_with_flickr

class Photo_with_flickrTests: XCTestCase {

     var sut: MainViewModel!
     var serviceAPI: MockApiService!
     var photos: [PhotoElement] = []
   
    override func setUpWithError() throws {
        serviceAPI = MockApiService()
        sut = MainViewModel(apiService: serviceAPI)
        let photo: Photo = Photo(photos: Photos(page: 22,
                                                pages: 33,
                                                perpage: 44,
                                                total: 44, photo:
                                                    [PhotoElement(id: "51968995131",
                                                                  owner: "32309295@N08",
                                                                  secret: "46bb603793",
                                                                  server: "65535",
                                                                  farm: 66,
                                                                  title: "keep some room in your heart for the unimaginable.",
                                                                  isFav: true,
                                                                  urlImage: URL(string: "http://farm66.static.flickr.com/65535/51968995131_46bb603793.jpg"))]), stat: "")
        
        serviceAPI.photo = photo
        Task {
            let result: Result<Photo, Error> = try await serviceAPI.getPhotos()
            switch result {
            case .failure(let error):
                print(error)
            case .success(let photos):
                let favIds = UserDefaultsHelper.shared.getFavoritesIDs()
                for id in favIds {
                    photos.photos?.photo.filter({$0.id == id}).first?.isFav = true
                }
                self.photos = photos.photos?.photo ?? []
                print(photos)
            }
        }
        
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        serviceAPI = nil
        sut = nil
        try super.tearDownWithError()
    }

    func testUpdateDataOnSuccess() async throws {
        //given
        let photo: Photo = Photo(photos: Photos(page: 22,
                                                pages: 33,
                                                perpage: 44,
                                                total: 44, photo:
                                                    [PhotoElement(id: "51968995131",
                                                                  owner: "32309295@N08",
                                                                  secret: "46bb603793",
                                                                  server: "65535",
                                                                  farm: 66,
                                                                  title: "keep some room in your heart for the unimaginable.",
                                                                  isFav: true,
                                                                  urlImage: URL(string: "http://farm66.static.flickr.com/65535/51968995131_46bb603793.jpg"))]), stat: "")
        
        serviceAPI.photo = photo
        //when
        sut.getPhotos()
        
        //then
        XCTAssertEqual(photos[0].id, "51968995131")
    }
    func testUpdateDataOnFailure() {
        //given
        let photo: Photo = Photo(photos: Photos(page: 22,
                                                pages: 33,
                                                perpage: 44,
                                                total: 44, photo:
                                                    []), stat: "")
        serviceAPI.photo = photo
        //when
        sut.getPhotos()
        //then
        XCTAssertEqual(photos.count, 0)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testSearchDataOnSuccess() async throws {
        //given
        let photo: Photo = Photo(photos: Photos(page: 22,
                                                pages: 33,
                                                perpage: 44,
                                                total: 44, photo:
                                                    [PhotoElement(id: "51968995131",
                                                                  owner: "32309295@N08",
                                                                  secret: "46bb603793",
                                                                  server: "65535",
                                                                  farm: 66,
                                                                  title: "keep some room in your heart for the unimaginable.",
                                                                  isFav: true,
                                                                  urlImage: URL(string: "http://farm66.static.flickr.com/65535/51968995131_46bb603793.jpg"))]), stat: "")
        
        serviceAPI.photo = photo
        //when
        sut.searchPhotosBy("cat")
        
        //then
        XCTAssertEqual(photos[0].id, "51968995131")
    }
    func test_SearchDataOnFailure() {
        //given
        let photo: Photo = Photo(photos: Photos(page: 22,
                                                pages: 33,
                                                perpage: 44,
                                                total: 44, photo:
                                                    []), stat: "")
        serviceAPI.photo = photo
        //when
        sut.searchPhotosBy("cat")
        //then
        XCTAssertEqual(photos.count, 0)
    }

}


class MockApiService: ApiProtocol {
    
    var photo: Photo!

    func getPhotos() async throws -> Result<Photo, Error> {
       return .success(photo)
    }
    
    func searchPhotosBy(_ text: String) async throws -> Result<Photo, Error> {
        return .success(photo)
    }
    
}
