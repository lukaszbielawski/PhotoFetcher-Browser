//
//  FavouritesService.swift
//  PhotoFetcher-Browser
//
//  Created by Łukasz Bielawski on 05/09/2023.
//

import Foundation

protocol FavouritesService {
    func storeImageInFavourites(image: ImageData)
    func removeImageFromFavourites(image: ImageData)
}
