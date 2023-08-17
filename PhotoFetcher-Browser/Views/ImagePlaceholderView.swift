//
//  ImagePlaceholderView.swift
//  PhotoFetcher-Browser
//
//  Created by Łukasz Bielawski on 17/08/2023.
//

import SwiftUI

struct ImagePlaceholderView: View {
    let geo: GeometryProxy

    var body: some View {
        ProgressView()
            .frame(width: geo.size.width * 0.45, height: geo.size.width * 0.45)
            .background(Color.gray.cornerRadius(16))
    }
}
