//
//  PhotoTileView.swift
//  PhotoFetcher-Browser
//
//  Created by Łukasz Bielawski on 04/09/2023.
//

import Kingfisher
import SwiftUI

struct PhotoTileView<Moderator: FavouritesModerator>: View {
    var imageData: ImageData
    var geoWidth: CGFloat?
    var imageSize: ImageSize = .small

    @ObservedObject var moderator: Moderator
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
                .url(URL(string: imageData.urls![keyPath: imageSize.keyPath]))
                .placeholder {
                    ImagePlaceholderView(geoWidth: geoWidth)
                }
                .resizable()
                .cancelOnDisappear(true)
                .scaledToFill()
                .if(geoWidth != nil) { view in
                    view.frame(width: geoWidth, height: geoWidth)
                }
                .contentShape(Rectangle())
                .cornerRadius(16)
                .onTapGesture(count: 2) {
                    if !(self.isHearted) {
                        self.isHearted = true

                        self.isFavourite.toggle()
                        if self.isFavourite {
                            moderator.favouritesManager.storeImageInFavourites(image: imageData)
                        } else {
                            moderator.favouritesManager.removeImageFromFavourites(image: imageData)
                        }
                    }
                }

            HeartView(isHearted: $isHearted,
                      dampingFraction: $dampingFraction,
                      isFavourite: $isFavourite,
                      geoWidth: geoWidth)
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

        var geoWidth: CGFloat?

        var body: some View {
            Image(systemName: isFavourite ? "heart.fill" : "heart.slash.fill")
                .resizable()
                .foregroundColor(Color.white)
                .if(geoWidth != nil) { view in
                    view.frame(width: geoWidth! * 0.33, height: geoWidth! * 0.33)
                }
                .shadow(radius: 4.0)
                .scaleEffect(isHearted ? 1.0 : 0.001)
                .animation(Animation.spring(response: 0.25,
                                            dampingFraction: dampingFraction),
                           value: isHearted)
        }
    }
}
