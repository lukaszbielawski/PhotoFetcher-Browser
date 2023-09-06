//
//  PhotoTileView.swift
//  PhotoFetcher-Browser
//
//  Created by Łukasz Bielawski on 04/09/2023.
//

import Kingfisher
import SwiftUI

struct PhotoTileView: View {
    var imageData: ImageData
    var geoWidth: CGFloat
    var imageSize: ImageSize = .small

//    @ObservedObject var moderator: Moderator
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
                .url(URL(string: imageData.urls[keyPath: imageSize.keyPath]))
                .placeholder {
                    ImagePlaceholderView(geoWidth: geoWidth)
                }
                .resizable()
                .cancelOnDisappear(true)
                .retry(DelayRetryStrategy(maxRetryCount: 10, retryInterval: .seconds(10)))
                .scaledToFill()
                .frame(width: geoWidth, height: geoWidth)
                .contentShape(Rectangle())
                .cornerRadius(16)
                .onTapGesture(count: 2) {
                    if !(self.isHearted) {
                        self.isHearted = true
                        self.isFavourite = !FavouritesManager.isAlreadyFavourite(imageData: imageData)

                        if self.isFavourite {
                            FavouritesManager.storeImageInFavourites(imageData: imageData)
                        } else {
                            FavouritesManager.removeImageFromFavourites(imageData: imageData)
                        }
                    }
                }

            HeartView(isHearted: $isHearted,
                      dampingFraction: $dampingFraction,
                      isFavourite: $isFavourite,
                      geoWidth: geoWidth)
                .allowsHitTesting(false)
        }.onAppear {
            isFavourite = FavouritesManager.isAlreadyFavourite(imageData: imageData)
        }
    }
}

private extension PhotoTileView {
    struct HeartView: View {
        @Binding var isHearted: Bool
        @Binding var dampingFraction: Double
        @Binding var isFavourite: Bool

        var geoWidth: CGFloat

        var body: some View {
            Image(systemName: isFavourite ? "heart.fill" : "heart.slash.fill")
                .resizable()
                .foregroundColor(Color.white)
                .frame(width: geoWidth * 0.33, height: geoWidth * 0.33)
                .shadow(radius: 4.0)
                .scaleEffect(isHearted ? 1.0 : 0.001)
                .animation(Animation.spring(response: 0.25,
                                            dampingFraction: dampingFraction),
                           value: isHearted)
        }
    }
}
