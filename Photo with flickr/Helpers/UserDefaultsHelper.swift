//
//  UserDefaultsHelper.swift
//  Photo with flickr
//
//  Created by Oleg Ten on 30/07/2022.
//

import Foundation

class UserDefaultsHelper {
    
    static var shared = UserDefaultsHelper()
   
    private var storage = UserDefaults()
    
    func getFavoritesIDs() -> Set<String>{
        guard let allFavoritesIDs = storage.object(forKey: "FavoritesIDs") as? Data,
              let favoritesIDs = try? JSONDecoder().decode(Set<String>.self, from: allFavoritesIDs) else {
            return []
        }
        return favoritesIDs
    }
    
    func addNewFavoritPhotoWith(_ Id: String) {
        var allFavoritesIDs = getFavoritesIDs()
        allFavoritesIDs.insert(Id)
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(allFavoritesIDs) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "FavoritesIDs")
        }
        
        print(getFavoritesIDs())
    }
}
