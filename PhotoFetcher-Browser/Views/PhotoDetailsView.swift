//
//  PhotoDetailsView.swift
//  PhotoFetcher-Browser
//
//  Created by Łukasz Bielawski on 05/09/2023.
//

import SwiftUI

struct PhotoDetailsView: View {
    var imageData: ImageData
    @StateObject var viewModel = PhotoDetailsViewModel()

    var body: some View {
        GeometryReader { geo in
            VStack {
                HStack {
                    Spacer()
                    PhotoTileView(imageData: imageData,
                                  geoWidth: geo.size.width,
                                  imageSize: .regular,
                                  moderator: viewModel)
                    Spacer()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct PhotoDetailsView_Previews: PreviewProvider {
    static var previews: some View {
//        PhotoDetailsView()
        EmptyView()
    }
}
