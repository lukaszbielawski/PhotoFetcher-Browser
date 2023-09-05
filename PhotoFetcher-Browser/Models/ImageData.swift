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
    let width, height: Int?
    let description: String?
    let altDescription: String?
    let urls: Urls
//    let user: User

    enum CodingKeys: String, CodingKey {
        case id, slug
        case width, height
        case description
        case altDescription = "alt_description"
        case urls
//        case user
    }

    struct User: Codable {
        let id: String?
        let username, name, firstName: String?
        let lastName: String?
        let profileImage: ProfileImage

        enum CodingKeys: String, CodingKey {
            case id
            case username, name
            case firstName = "first_name"
            case lastName = "last_name"
            case profileImage = "profile_image"
        }

        struct ProfileImage: Codable {
            let small, medium, large: String
        }
    }

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
