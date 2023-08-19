//
//  PhotoBrowserView.swift
//  PhotoFetcher-Browser
//
//  Created by Łukasz Bielawski on 16/08/2023.
//

import Kingfisher
import SwiftUI

struct PhotoBrowserView: View {
    @StateObject var viewModel = PhotoBrowserViewModel()

    private let cacheKey = "cache_key"

    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        GeometryReader { geo in
            ScrollView {
                LazyVGrid(columns: columns, spacing: geo.size.width * 0.025) {
                    ForEach(Array(viewModel.imagesData.enumerated()), id: \.1.id) { index, imageData in
//                            AsyncImage(url: URL(string: imageData.urls!.regular!)) { image in
//                                image
//                                    .resizable()
//                                    .scaledToFill()
//                                    .frame(width: geo.size.width * 0.45, height: geo.size.width * 0.45)
//                                    .cornerRadius(16)
                        KFImage
//                        (source: .network(KF.ImageResource(downloadURL: URL(string: imageData.urls!.regular!)!, cacheKey: cacheKey)))
                            .url(URL(string: imageData.urls!.regular!))
                            .resizable()
                            .placeholder {
                                ImagePlaceholderView(geo: geo)
                            }
                            .forceRefresh(true)
                            .cancelOnDisappear(true)
                            .scaledToFill()
                            .frame(width: geo.size.width * 0.45, height: geo.size.width * 0.45)
                            .cornerRadius(16)
//                        } placeholder: {
//                            ImagePlaceholderView(geo: geo)
//                        }
                            .onAppear {
                                print(index)

                                if index + 1 == $viewModel.imagesData.count {
                                    print("no data")

                                    viewModel.page += 1
                                    DispatchQueue.main.async {
                                        viewModel.loadFetchRequest()
                                    }
                                }
                            }
                            .onDisappear {
//                                KingfisherManager.shared.cache.removeImage(
//                                    forKey: cacheKey,
//                                    fromMemory: false,
//                                    fromDisk: true)
//                                {
//                                    print("Removed!")
//                                }
                                KingfisherManager.shared.cache.clearCache()
                            }
                    }
                }
                .padding(geo.size.width * 0.025)
            }
        }
        .task {
            viewModel.loadFetchRequest()
        }
    }
}

struct PhotoBrowserView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoBrowserView(viewModel: PhotoBrowserViewModel(service: FakeImageService()))
    }
}
