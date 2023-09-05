//
//  PhotoBrowserView.swift
//  PhotoFetcher-Browser
//
//  Created by Łukasz Bielawski on 16/08/2023.
//

import SwiftUI

struct PhotoBrowserView: View {
    @StateObject var imageLoader =
        ImageLoaderViewModel(service: NetworkImageSerivce())

    var body: some View {
        PhotoScrollView(imageLoader: imageLoader)
    }
}

struct PhotoBrowserView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoBrowserView(imageLoader: ImageLoaderViewModel(service: FakeImageService()))
    }
}
