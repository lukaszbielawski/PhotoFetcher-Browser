//
//  FavouritesImageSerivce.swift
//  PhotoFetcher-Browser
//
//  Created by Łukasz Bielawski on 04/09/2023.
//

import Combine
import Foundation

struct FavouritesImageService: ImageService {
    func fetchImagesData(query: String = "") -> AnyPublisher<[ImageData], Error> {
        return UserDefaults.standard.array(forKey: "favourites")
            .publisher
            .tryMap { array in
                let decoder = JSONDecoder()
                let dataArray = try array.map { id in
                    let data = UserDefaults.standard.object(forKey: (id as? String)!) as? Data
                    guard let imageData = try? decoder.decode(ImageData.self, from: data!) else {
                        throw ImageError.decodingError
                    }
                    return imageData
                }
                return dataArray
            }
            .mapError { _ in
                ImageError.decodingError
            }
            .eraseToAnyPublisher()
    }
}
