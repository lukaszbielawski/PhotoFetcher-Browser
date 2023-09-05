//
//  FavouritesService.swift
//  PhotoFetcher-Browser
//
//  Created by Łukasz Bielawski on 05/09/2023.
//

import Foundation

protocol FavouritesService {
    func storeImageInFavourites(imageData: ImageData)
    func removeImageFromFavourites(imageData: ImageData)
    func isAlreadyFavourite(imageData: ImageData) -> Bool
}
