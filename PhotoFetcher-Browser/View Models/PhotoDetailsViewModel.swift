//
//  PhotoDetailsViewModel.swift
//  PhotoFetcher-Browser
//
//  Created by Łukasz Bielawski on 05/09/2023.
//

import Foundation

class PhotoDetailsViewModel: ObservableObject, FavouritesModerator {
    var favouritesManager: FavouritesService = FavouritesManager()
    let imageData: ImageData

    @Published var isFavourite: Bool

    init(favouritesManager: FavouritesService, imageData: ImageData) {
        self.favouritesManager = favouritesManager
        self.imageData = imageData
        self.isFavourite = favouritesManager.isAlreadyFavourite(imageData: imageData)
    }
}
