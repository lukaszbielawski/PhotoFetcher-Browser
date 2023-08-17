//
//  ImageModel.swift
//  PhotoFetcher-Browser
//
//  Created by Łukasz Bielawski on 16/08/2023.
//

import Foundation

struct ImageData: Decodable, Encodable, Identifiable {
    let id: UUID = .init()

    let slug: String?
    let createdAt, updatedAt: Date?
    let promotedAt: Date?
    let width, height: Int?
    let color, blurHash: String?
    let description, altDescription: String?
    let urls: Urls?

    struct Urls: Codable {
        let raw, full, regular, small, thumb: String?
    }
}
