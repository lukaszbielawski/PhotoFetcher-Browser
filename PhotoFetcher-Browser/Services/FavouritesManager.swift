//
//  FavouritesManager.swift
//  PhotoFetcher-Browser
//
//  Created by Łukasz Bielawski on 05/09/2023.
//

import Foundation

struct FavouritesManager: FavouritesService {
    func isAlreadyFavourite(imageData: ImageData) -> Bool {
        return UserDefaults.standard.array(forKey: "favourites")?.contains(where: { slug in
            imageData.slug == (slug as? String)!
        }) ?? false
    }
    
    func storeImageInFavourites(imageData: ImageData) {
        let favouritesKey = "favourites"
        let userDefaults = UserDefaults.standard

        let encoder = JSONEncoder()
        guard let encodedImage = try? encoder.encode(imageData) else { return }

        userDefaults.set(encodedImage, forKey: imageData.slug)

        guard var array = userDefaults.array(forKey: favouritesKey) else {
            userDefaults.set([imageData.slug], forKey: favouritesKey)
            return
        }
        array.append(imageData.slug)
        userDefaults.removeObject(forKey: favouritesKey)
        userDefaults.set(array, forKey: favouritesKey)
    }

    func removeImageFromFavourites(imageData: ImageData) {
        let favouritesKey = "favourites"
        let userDefaults = UserDefaults.standard

        userDefaults.removeObject(forKey: imageData.slug)

        guard var array = userDefaults.array(forKey: favouritesKey) as? [String] else { return}
        array.removeAll(where: { $0 == imageData.slug })
        userDefaults.removeObject(forKey: favouritesKey)
        userDefaults.set(array, forKey: favouritesKey)
    }
}
