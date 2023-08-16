//
//  ImageFetcher.swift
//  PhotoFetcher-Browser
//
//  Created by Łukasz Bielawski on 16/08/2023.
//

import Foundation

struct ImageFetcher {
    func fetch(from imageUrl: String) async throws -> Data {
        guard let url = URL(string: imageUrl) else {
            throw FetcherError.invalidUrl
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }
}

extension ImageFetcher {
    private enum FetcherError: Error {
        case invalidUrl
    }
}
