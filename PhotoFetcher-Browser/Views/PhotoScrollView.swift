//
//  PhotoScrollView.swift
//  PhotoFetcher-Browser
//
//  Created by Łukasz Bielawski on 04/09/2023.
//

import Kingfisher
import SwiftUI
import UIKit

struct PhotoScrollView<Loader: ImageLoader>: View {
    @State private var favouritesChanged: Bool = false
    @ObservedObject var imageLoader: Loader

    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        NavigationView {
            GeometryReader { geo in
                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: columns, spacing: geo.size.width * 0.025) {
                        ForEach(Array(imageLoader.imagesData.enumerated()), id: \.1.id) { index, imageData in
                            NavigationLink(destination:
                                PhotoDetailsView(imageData: imageData,
                                                 viewModel: PhotoDetailsViewModel(imageData: imageData)))
                            {
                                PhotoTileView(imageData: imageData,
                                              geoWidth: geo.size.width * 0.45)
                                    .task {
                                        if !imageLoader.isFinite {
                                            if index + 1 == $imageLoader.imagesData.count {
                                                print("load")
                                                imageLoader.loadFetchRequest()
                                            }
                                        }
                                    }
                            }
                        }
                    }
                    .padding(geo.size.width * 0.025)
                    .buttonStyle(.empty)
                    .navigationBarHidden(true)
                    .onAppear {
                        ImageCache.default.memoryStorage.config.totalCostLimit = 1024 * 1024 * 200
                    }
                    .task {
                        if imageLoader.imagesData.isEmpty || imageLoader.isFinite {
                            imageLoader.loadFetchRequest()
                        }
                    }
                }
            }.background(Color.primaryColor)
        }
    }
}

struct PhotoScrollView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoScrollView(imageLoader: ImageLoaderViewModel(service: FakeImageService()))
    }
}
