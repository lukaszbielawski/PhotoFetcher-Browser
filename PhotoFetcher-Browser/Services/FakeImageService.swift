//
//  FakeImageService.swift
//  PhotoFetcher-Browser
//
//  Created by Łukasz Bielawski on 17/08/2023.
//

import Combine
import Foundation

struct FakeImageService: ImageService {
    func fetchImagesData() -> AnyPublisher<[ImageData], Error> {
        return Bundle.main
            .url(forResource: "fakeData", withExtension: "json")
            .publisher
            .tryMap { string in
                guard let data = try? Data(contentsOf: string) else {
                    fatalError("failed")
                }
                return data
            }
            .decode(type: [ImageData].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
