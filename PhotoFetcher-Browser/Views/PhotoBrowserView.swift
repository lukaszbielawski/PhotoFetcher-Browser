//
//  PhotoScrollView.swift
//  PhotoFetcher-Browser
//
//  Created by Łukasz Bielawski on 04/09/2023.
//

import Kingfisher
import SwiftUI
import UIKit

struct PhotoBrowserView: View {
    @StateObject var viewModel: ImageLoaderViewModel

    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    init(viewModel: ImageLoaderViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationView {
            GeometryReader { geo in
                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: columns, spacing: geo.size.width * 0.025) {
                        ForEach(Array(viewModel.imagesData.enumerated()), id: \.1.id) { index, imageData in
                            NavigationLink(destination:
                                PhotoDetailsView(viewModel:
                                    PhotoDetailsViewModel(imageData: imageData),
                                    detailsPresented: $viewModel.detailsPresented,
                                    imageData: imageData)
                                    .onAppear {
                                        viewModel.detailsPresented = true
                                    }

                            ) {
                                PhotoTileView(imageData: imageData,
                                              geoWidth: geo.size.width * 0.45)
                                    .task {
                                        if !viewModel.isFinite {
                                            if index + 1 == $viewModel.imagesData.count {
                                                print("load")
                                                viewModel.loadFetchRequest(query: "")
                                            }
                                        }
                                    }
                            }
                        }
                    }

                    .padding([.horizontal], geo.size.width * 0.025)
                    .buttonStyle(.empty)
                    .navigationBarHidden(true)

                    .onAppear {
                        ImageCache.default.memoryStorage.config.totalCostLimit = 1024 * 1024 * 200
                    }
                    .task {
                        if viewModel.imagesData.isEmpty || viewModel.isFinite {
                            if viewModel.firstAppear || viewModel.isFinite {
                                viewModel.firstAppear = false
                                viewModel.loadFetchRequest(query: "")
                            }
                        }
                    }
                }
                .background(Color.primaryColor)
            }
        }.preference(key: SearchViewHiddenPreferenceKey.self, value: viewModel.detailsPresented)
    }
}

struct PhotoScrollView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoBrowserView(viewModel: ImageLoaderViewModel(service: FakeImageService()))
    }
}
