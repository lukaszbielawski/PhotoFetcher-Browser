//
//  PhotoDetailsView.swift
//  PhotoFetcher-Browser
//
//  Created by Łukasz Bielawski on 05/09/2023.
//

import Combine
import Kingfisher
import LinkPresentation
import SwiftUI

struct PhotoDetailsView: View {
    @StateObject var viewModel: PhotoDetailsViewModel
    @Binding var detailsPresented: Bool

    @Environment(\.dismiss) var dismiss

    let imageData: ImageData

    var body: some View {
        GeometryReader { geo in
            ScrollView {
                VStack {
                    HStack {
                        Spacer()
                        ZStack {
                            PhotoTileView(imageData: imageData,
                                          geoWidth: geo.size.width * 0.9,
                                          imageSize: .regular)
                                .simultaneousGesture(TapGesture(count: 2).onEnded {
                                    if !(viewModel.isHearted) {
                                        viewModel.isHearted = true
                                        viewModel.isFavourite =
                                            !FavouritesManager.isAlreadyFavourite(imageData: imageData)
                                    }
                                })
                            switch viewModel.state {
                            case .nan:
                                EmptyView()
                            case .loading:
                                ProgressView()
                                    .scaleEffect(2)
                                    .frame(width: geo.size.width * 0.9, height: geo.size.width * 0.9)
                                    .background(Color.black.opacity(0.2))

                                    .clipShape(RoundedRectangle(cornerRadius: 16))

                            case .success:
                                CompletionView(systemImage: "checkmark.circle.fill", width: geo.size.width * 0.35)
                                    .environmentObject(viewModel)
                            default:
                                CompletionView(systemImage: "xmark.circle.fill", width: geo.size.width * 0.35)
                                    .environmentObject(viewModel)
                            }
                        }
                        Spacer()
                    }
                    Group {
                        DetailsButtonsView(geoWidth: geo.size.width * 0.9 - 24.0)
                        PhotoDetailsDescriptionView(geoWidth: geo.size.width * 0.9 - 24.0)
                    }
                    .padding(8)
                    .environmentObject(viewModel)
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(leading:
                                        Button(action: {
                    dismiss()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        detailsPresented = false
                    }
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Back")
                            .fontWeight(.medium)
                    }
                    .foregroundColor(Color.accentColor)
                })
            }
            .onAppear {
//                UINavigationBar.appearance().barTintColor = UIColor(Color.primaryColor)
//                UINavigationBar.appearance().isTranslucent = true
                viewModel.isFavourite = FavouritesManager.isAlreadyFavourite(imageData: imageData)
            }
            .background(Color.primaryColor)
            .foregroundColor(Color.white)
        }
    }
}

extension PhotoDetailsView {
    struct CompletionView: View {
        let systemImage: String
        let width: CGFloat

        @State var justAppeared = false
        @EnvironmentObject var viewModel: PhotoDetailsViewModel

        var body: some View {
            Image(systemName: systemImage)
                .resizable()
                .frame(width: width, height: width)
                .opacity(justAppeared ? 1.0 : 0)
                .animation(.easeOut(duration: 0.75), value: justAppeared)
                .onAppear {
                    justAppeared = true
                    withAnimation {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            justAppeared = false
                        }
                    }
                }
                .onDisappear {
                    self.viewModel.state = ImageDownloadState.nan
                }
        }
    }
}

extension PhotoDetailsView {
    struct PhotoDetailsDescriptionView: View {
        @EnvironmentObject var viewModel: PhotoDetailsViewModel
        var geoWidth: CGFloat

        var body: some View {
            HStack(alignment: .top, spacing: 8) {
                UserProfileImageView(geoWidth: geoWidth)
                    .padding(.leading, geoWidth * 0.05)
                    .environmentObject(viewModel)
                VStack(alignment: .center, spacing: 8) {
                    Text("""
                    Photo by \(viewModel.imageData.user.firstName) \
                    \(viewModel.imageData.user.lastName != nil ? "\(viewModel.imageData.user.lastName!) " : "")\
                    on Unsplash
                    """)
                    .font(UIDevice.current.userInterfaceIdiom == .pad ? .title : .none)
                    .fontWeight(.medium)
                    .frame(width: geoWidth * 0.65 - 8.0)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .foregroundColor(.secondaryColor)

                    DetailButtonView(systemImage: "globe",
                                     color: Color.accentColor,
                                     width: geoWidth * 0.5,
                                     height: geoWidth * 0.15,
                                     title: "Homepage")
                    {
                        UIApplication.shared.open(URL(string: viewModel.imageData.user.links.html)!)
                    }
                    Spacer(minLength: geoWidth * 0.20)
                }
                Spacer()
            }
        }
    }

    struct UserProfileImageView: View {
        @EnvironmentObject var viewModel: PhotoDetailsViewModel
        var geoWidth: CGFloat

        var body: some View {
            KFImage
                .url(URL(string: viewModel.imageData.user.profileImage.large))
                .placeholder {
                    ImagePlaceholderView(geoWidth: geoWidth * 0.25)
                        .clipShape(Circle())
                }
                .resizable()
                .cancelOnDisappear(true)
                .retry(DelayRetryStrategy(maxRetryCount: 10, retryInterval: .seconds(10)))
                .scaledToFit()
                .frame(maxHeight: geoWidth * 0.25)
                .clipShape(Circle())
        }
    }
}
