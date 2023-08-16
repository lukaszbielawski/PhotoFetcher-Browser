//
//  CachedImageManager.swift
//  PhotoFetcher-Browser
//
//  Created by Łukasz Bielawski on 16/08/2023.
//

import Foundation

extension CachedImage {
    final class Model: ObservableObject {
        @Published private(set) var data: Data?

        private let imageFetcher = ImageFetcher()

        @MainActor func load(from imageUrl: String) async {
            do {
                print("xd")
                data = try await imageFetcher.fetch(from: imageUrl)
            } catch {
                print(error)
            }
        }
    }
}
