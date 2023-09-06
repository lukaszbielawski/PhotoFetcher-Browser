//
//  ImageFetcherService.swift
//  PhotoFetcher-Browser
//
//  Created by Łukasz Bielawski on 06/09/2023.
//

import Combine
import Foundation
import SwiftUI

struct ImageFetcherService {
    func fetchImageFromUrl(url: URL) -> AnyPublisher<UIImage, Error> {
        URLSession.shared
            .dataTaskPublisher(for: url)
            .receive(on: DispatchQueue.main)
            .tryMap { res in
                guard let response = res.response as? HTTPURLResponse,
                      response.statusCode >= 200 && response.statusCode < 300
                else {
                    throw ImageError.invalidUrlError
                }

                guard let image = UIImage(data: res.data) else {
                    throw ImageError.decodingError
                }
                return image
            }
            .eraseToAnyPublisher()
    }
}
