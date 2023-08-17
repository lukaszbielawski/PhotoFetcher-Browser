//
//  ImageService.swift
//  PhotoFetcher-Browser
//
//  Created by Łukasz Bielawski on 17/08/2023.
//

import Combine
import Foundation

protocol ImageService {
    func fetchImagesData(page: Int, perPage: Int) -> AnyPublisher<[ImageData], Error>
}
