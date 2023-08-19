//
//  PhotoFetcher.swift
//  PhotoFetcher-Browser
//
//  Created by Łukasz Bielawski on 16/08/2023.
//

import Combine
import Foundation

class NetworkImageSerivce: ImageService, ObservableObject {
//    private let accessKey = "Xc9971_FxoJjf26tp8nGcsp27SgViu3jeBwjtGMBFU8"
    private let accessKey = "raZSla36FOClHcq0XbxLAf5qOaQiGW6cvGjlDg58yHM"

    func fetchImagesData(page: Int, perPage: Int = 30) -> AnyPublisher<[ImageData], Error> {
        print("page \(page)")

        let urlScheme = "https://api.unsplash.com/photos?page=\(page)&per_page=\(perPage)&client_id=\(accessKey)"
        let url = URL(string: urlScheme)
        guard let url else {
            return Fail(error: ImageError.invalidUrlError)
                .eraseToAnyPublisher()
        }

        return URLSession.shared
            .dataTaskPublisher(for: url)
            .receive(on: DispatchQueue.main)
            .tryMap { res in
                guard let response = res.response as? HTTPURLResponse,
                      response.statusCode >= 200 && response.statusCode < 300
                else {
                    throw ImageError.responseCodeError
                }

                guard let images = try? JSONDecoder().decode([ImageData].self, from: res.data) else {
                    throw ImageError.decodingError
                }
                return images
            }
            .eraseToAnyPublisher()
    }
}
