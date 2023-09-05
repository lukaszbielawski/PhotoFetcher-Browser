//
//  PhotoDetailsView.swift
//  PhotoFetcher-Browser
//
//  Created by Łukasz Bielawski on 05/09/2023.
//

import SwiftUI

struct PhotoDetailsView: View {
    let imageData: ImageData
    @StateObject var viewModel: PhotoDetailsViewModel

    init(imageData: ImageData) {
        self.imageData = imageData
        self._viewModel = StateObject(wrappedValue:
            PhotoDetailsViewModel(
                favouritesManager: FavouritesManager(),
                imageData: imageData)
        )
    }

    var body: some View {
            GeometryReader { geo in
                ScrollView {
                VStack {
                    HStack {
                        Spacer()
                        PhotoTileView(imageData: imageData,
                                      geoWidth: geo.size.width * 0.9,
                                      imageSize: .regular,
                                      moderator: viewModel)
                        Spacer()
                    }
                    DetailsButtonsView(geoWidth: geo.size.width * 0.9 - 24.0)
                        .padding(8)
                    //TODO:
//                    DetailsDescriptionView()
                }
                .navigationBarTitleDisplayMode(.inline)
            }
            .background(Color.primaryColor)
            .foregroundColor(Color.white)
        }
    }
}

extension PhotoDetailsView {
    struct DetailsButtonsView: View {
        let geoWidth: CGFloat

        var body: some View {
            HStack(spacing: 8) {
                DetailButtonView(systemImage: "heart.fill",
                                 color: .heartColor,
                                 width: geoWidth * 0.25,
                                 height: geoWidth * 0.15,
                                 title: nil)
                DetailButtonView(systemImage: "square.and.arrow.down.fill",
                                 color: .downloadColor,
                                 width: geoWidth * 0.40,
                                 height: geoWidth * 0.15,
                                 title: "Download")
                DetailButtonView(systemImage: "arrowshape.turn.up.backward.fill",
                                 color: .shareColor,
                                 width: geoWidth * 0.35,
                                 height: geoWidth * 0.15,
                                 title: "Share")
            }
        }
    }

    struct DetailButtonView: View {
        let systemImage: String
        let color: Color
        let width: CGFloat
        let height: CGFloat
        let title: String?

        var body: some View {
            Group {
                if let title {
                    Label(title, systemImage: systemImage)
                } else {
                    Image(systemName: systemImage)
                }
            }
            .padding(8)
            .frame(maxWidth: width, maxHeight: height)
            .background(color)
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
}

struct PhotoDetailsView_Previews: PreviewProvider {
    static var previews: some View {
//        PhotoDetailsView()
        EmptyView()
    }
}
