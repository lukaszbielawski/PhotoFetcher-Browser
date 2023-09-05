//
//  FavouritesEditor.swift
//  PhotoFetcher-Browser
//
//  Created by Łukasz Bielawski on 05/09/2023.
//

import Foundation

protocol FavouritesModerator: ObservableObject {
    var favouritesManager: FavouritesService { get set }
}
