//
//  PhotoBrowserView.swift
//  PhotoFetcher-Browser
//
//  Created by Łukasz Bielawski on 16/08/2023.
//

import Kingfisher
import SwiftUI

struct PhotoBrowserView: View {
    @StateObject var imageLoader =
        ImageLoaderViewModel(service: NetworkImageSerivce())
//    ImageLoaderViewModel()

    var body: some View {
        PhotoScrollView(viewModel: imageLoader)
            .onAppear {
                ImageCache.default.memoryStorage.config.totalCostLimit = 1024 * 1024 * 200
//                imageLoader.resetDefaults()
            }
            .task {
                if imageLoader.isFinite || imageLoader.imagesData.isEmpty {
                    imageLoader.loadFetchRequest()
                }
            }
    }
}

struct PhotoBrowserView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoBrowserView(imageLoader: ImageLoaderViewModel(service: FakeImageService()))
    }
}
