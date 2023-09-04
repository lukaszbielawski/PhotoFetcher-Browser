//
//  PhotoScrollView.swift
//  PhotoFetcher-Browser
//
//  Created by Łukasz Bielawski on 04/09/2023.
//

import SwiftUI

struct PhotoScrollView<Loader: ImageLoader>: View {
    @ObservedObject var viewModel: Loader

    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        GeometryReader { geo in
            ScrollView {
                LazyVGrid(columns: columns, spacing: geo.size.width * 0.025) {
                    ForEach(Array(viewModel.imagesData.enumerated()), id: \.1.id) { index, imageData in
                        PhotoTileView(imageData: imageData, geo: geo, index: index, imageLoader: viewModel)
                    }
                }
                .padding(geo.size.width * 0.025)
            }
        }
    }
}

struct PhotoScrollView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoScrollView(viewModel: ImageLoaderViewModel(service: FakeImageService()))
    }
}
