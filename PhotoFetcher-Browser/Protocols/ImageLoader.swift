//
//  ImageLoader.swift
//  PhotoFetcher-Browser
//
//  Created by Łukasz Bielawski on 04/09/2023.
//

import Foundation
import SwiftUI

protocol ImageLoader: ObservableObject {
    var imagesData: [ImageData] { get set }
    var isFinite: Bool { get set }
    func loadFetchRequest()
}
