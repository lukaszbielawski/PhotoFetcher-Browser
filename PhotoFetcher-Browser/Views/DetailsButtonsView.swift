//
//  DetailButtonsView.swift
//  PhotoFetcher-Browser
//
//  Created by Łukasz Bielawski on 06/09/2023.
//

import SwiftUI

extension PhotoDetailsView {
    struct DetailsButtonsView: View {
        let geoWidth: CGFloat
        @EnvironmentObject var viewModel: PhotoDetailsViewModel

        var body: some View {
            HStack(spacing: 8) {
                DetailFavouritesButtonView(isFavourite: $viewModel.isFavourite,
                                           width: geoWidth * 0.25,
                                           height: geoWidth * 0.15)
                {
                    viewModel.isFavourite = !FavouritesManager.isAlreadyFavourite(imageData: viewModel.imageData)
                    if viewModel.isFavourite {
                        FavouritesManager.storeImageInFavourites(imageData: viewModel.imageData)
                    } else {
                        FavouritesManager.removeImageFromFavourites(imageData: viewModel.imageData)
                    }
                }

                DetailButtonView(systemImage: "square.and.arrow.down.fill",
                                 color: .downloadColor,
                                 width: geoWidth * 0.40,
                                 height: geoWidth * 0.15,
                                 title: "Download")
                {
                    viewModel.downloadAndStoreImageFromUrl(url: URL(string: viewModel.imageData.urls.full)!)
                }

                DetailButtonView(systemImage: "arrowshape.turn.up.backward.fill",
                                 color: .shareColor,
                                 width: geoWidth * 0.35,
                                 height: geoWidth * 0.15,
                                 title: "Share")
                {
                    ShareSheetPresenter.showShareSheet(url: viewModel.imageData.links.html,
                                                       iconUrl: viewModel.imageData.urls.thumb)
                }
            }
        }
    }

    struct DetailButtonView: View {
        let systemImage: String
        let color: Color
        let width: CGFloat
        let height: CGFloat
        let title: String
        let didTap: () -> Void

        var body: some View {
            Label(title, systemImage: systemImage)
                .padding(8)
                .frame(maxWidth: width, maxHeight: height)
                .background(color)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .onTapGesture {
                    didTap()
                }
        }
    }

    struct DetailFavouritesButtonView: View {
        @Binding var isFavourite: Bool

        let width: CGFloat
        let height: CGFloat
        let didTap: () -> Void

        var body: some View {
            Image(systemName: isFavourite ? "heart.fill" : "heart")
                .padding(8)
                .frame(maxWidth: width, maxHeight: height)
                .background(isFavourite ? Color.heartColor : Color.white)
                .foregroundColor(isFavourite ? Color.white : Color.heartColor)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(Color.heartColor, lineWidth: 1)
                )
                .animation(.linear(duration: 0.5), value: isFavourite)
                .onTapGesture {
                    didTap()
                }
        }
    }
}
