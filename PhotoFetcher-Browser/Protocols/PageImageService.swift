//
//  PageImageService.swift
//  PhotoFetcher-Browser
//
//  Created by Łukasz Bielawski on 04/09/2023.
//

import Foundation

protocol PageImageService: ImageService, ObservableObject {
    var page: Int { get set}
    var perPage: Int { get }
}
