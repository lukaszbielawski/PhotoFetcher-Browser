//
//  PhotoFetcher.swift
//  PhotoFetcher-Browser
//
//  Created by Łukasz Bielawski on 16/08/2023.
//

import Combine
import Foundation
import SwiftUI

class NetworkImageSerivce: ImageService {
    var page: Int = 0

    private let perPage: Int = 30

    private let accessKey = "raZSla36FOClHcq0XbxLAf5qOaQiGW6cvGjlDg58yHM"

    func fetchImagesData(query: String = "") -> AnyPublisher<[ImageData], Error> {
        page += 1

        let urlScheme = """
        https://api.unsplash.com/\(query != "" ? "search/" : "")photos?\
        page=\(page)&per_page=\(perPage)&client_id=\(accessKey)\(query != "" ? "&query=\(query)" : "")
        """

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

                guard let images = try? JSONDecoder().decode(self.returnType(query: query), from: res.data) else {
                    throw ImageError.decodingError
                }

                return query != "" ? (images as? SearchImageData)!.results : (images as? [ImageData])!
            }
            .eraseToAnyPublisher()
    }

    private func returnType(query: String) -> Decodable.Type {
        return query != "" ? SearchImageData.self : [ImageData].self
    }
}
