//
//  ImageError.swift
//  PhotoFetcher-Browser
//
//  Created by Łukasz Bielawski on 17/08/2023.
//

import Foundation

enum ImageError: Error {
    case invalidUrlError
    case responseCodeError
    case decodingError
    case otherError(error: Error)
}
