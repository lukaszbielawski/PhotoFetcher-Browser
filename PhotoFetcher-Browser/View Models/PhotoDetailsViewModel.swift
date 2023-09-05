//
//  PhotoDetailsViewModel.swift
//  PhotoFetcher-Browser
//
//  Created by Łukasz Bielawski on 05/09/2023.
//

import Foundation

class PhotoDetailsViewModel: ObservableObject, FavouritesModerator {
    var favouritesManager: FavouritesService = FavouritesManager()
    
}
