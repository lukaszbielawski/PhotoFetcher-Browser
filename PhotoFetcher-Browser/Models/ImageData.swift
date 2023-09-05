//
//  ImageModel.swift
//  PhotoFetcher-Browser
//
//  Created by Łukasz Bielawski on 16/08/2023.
//

import Foundation

struct ImageData: Codable, Identifiable {
    let id: UUID = .init()

    let slug: String
    let createdAt, updatedAt: Date?
    let promotedAt: Date?
    let width, height: Int?
    let color, blurHash: String?
    let description, altDescription: String?
    let urls: Urls?

    struct Urls: Codable {
        let raw, full, regular, small, thumb: String
    }
}

enum ImageSize {
    case raw, full, regular, small, thumb

    var keyPath: KeyPath<ImageData.Urls, String> {
        switch self {
        case .raw:
            return \.raw
        case .full:
            return \.full
        case .regular:
            return \.regular
        case .small:
            return \.small
        case .thumb:
            return \.thumb
        }
    }
}
