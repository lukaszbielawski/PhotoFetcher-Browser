//
//  ImageExtensions.swift
//  PhotoFetcher-Browser
//
//  Created by Łukasz Bielawski on 19/08/2023.
//

import Foundation
import SwiftUI

extension Image {

    func placeholderStyle(geo: GeometryProxy) -> some View {
        ProgressView()
            .frame(width: geo.size.width * 0.45, height: geo.size.width * 0.45)
            .background(Color.gray.cornerRadius(16))
    }
}
