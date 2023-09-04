//
//  PhotoTileView.swift
//  PhotoFetcher-Browser
//
//  Created by Łukasz Bielawski on 04/09/2023.
//

import Kingfisher
import SwiftUI

struct PhotoTileView<Loader: ImageLoader>: View {
    var imageData: ImageData
    var geo: GeometryProxy
    var index: Int

    @ObservedObject var imageLoader: Loader
    @State var dampingFraction: Double = 0.5
    @State var isFavourite: Bool = true
    @State var isHearted: Bool = false {
        didSet {
            guard isHearted else { return }
            dampingFraction = 0.5

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.125) {
                self.isHearted = false
                self.dampingFraction = 1.0
            }
        }
    }

    var body: some View {
        ZStack {
            KFImage
                .url(URL(string: imageData.urls!.small!))
                .placeholder {
                    ImagePlaceholderView(geo: geo)
                }
                .resizable()
                .cancelOnDisappear(true)
                .scaledToFill()
                .frame(width: geo.size.width * 0.45, height: geo.size.width * 0.45)
                .contentShape(Rectangle())
                .cornerRadius(16)
                .onAppear {
                    if !imageLoader.isFinite {
                        if index + 1 == $imageLoader.imagesData.count {
                            DispatchQueue.main.async {
                                print("load")
                                imageLoader.loadFetchRequest()
                            }
                        }
                    }
                }
                .onTapGesture(count: 2) {
                    if !(self.isHearted) {
                        self.isHearted = true

                        self.isFavourite.toggle()
                        if self.isFavourite {
                            try? imageLoader.storeImageInFavourites(image: imageData)
                        } else {
                            try? imageLoader.removeImageFromFavourites(image: imageData)
                        }
                    }
                }
            HeartView(isHearted: $isHearted, dampingFraction: $dampingFraction, isFavourite: $isFavourite, geo: geo)
                .allowsHitTesting(false)
        }.onAppear {
            if UserDefaults.standard.array(forKey: "favourites")?.contains(where: { slug in
                imageData.slug == (slug as? String)!
            }) ?? false {
                isFavourite = true
            } else {
                isFavourite = false
            }
        }
    }
}

private extension PhotoTileView {
    struct HeartView: View {
        @Binding var isHearted: Bool
        @Binding var dampingFraction: Double
        @Binding var isFavourite: Bool

        var geo: GeometryProxy

        var body: some View {
            Image(systemName: isFavourite ? "heart.fill" : "heart.slash.fill")
                .resizable()
                .foregroundColor(Color.white)
                .frame(width: geo.size.width * 0.15, height: geo.size.width * 0.15)
                .shadow(radius: 4.0)
                .scaleEffect(isHearted ? 1.0 : 0.001)
                .animation(Animation.spring(response: 0.25,
                                            dampingFraction: dampingFraction),
                           value: isHearted)
        }
    }
}
