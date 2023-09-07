//
//  ImageService.swift
//  PhotoFetcher-Browser
//
//  Created by Łukasz Bielawski on 17/08/2023.
//

import Combine
import Foundation

protocol ImageService {
    func fetchImagesData(query: String) -> AnyPublisher<[ImageData], Error>
}
