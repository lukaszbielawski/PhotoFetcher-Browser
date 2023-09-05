//
//  FavouritesManager.swift
//  PhotoFetcher-Browser
//
//  Created by Łukasz Bielawski on 05/09/2023.
//

import Foundation

struct FavouritesManager: FavouritesService {
    func storeImageInFavourites(image: ImageData) {
        let favouritesKey = "favourites"
        let userDefaults = UserDefaults.standard

        let encoder = JSONEncoder()
        guard let encodedImage = try? encoder.encode(image) else { return }

        userDefaults.set(encodedImage, forKey: image.slug)

        guard var array = userDefaults.array(forKey: favouritesKey) else {
            userDefaults.set([image.slug], forKey: favouritesKey)
            return
        }
        array.append(image.slug)
        userDefaults.removeObject(forKey: favouritesKey)
        userDefaults.set(array, forKey: favouritesKey)
    }

    func removeImageFromFavourites(image: ImageData) {
        let favouritesKey = "favourites"
        let userDefaults = UserDefaults.standard

        userDefaults.removeObject(forKey: image.slug)

        guard var array = userDefaults.array(forKey: favouritesKey) as? [String] else { return}
        array.removeAll(where: { $0 == image.slug })
        userDefaults.removeObject(forKey: favouritesKey)
        userDefaults.set(array, forKey: favouritesKey)
    }
}
