//
//  PhotoBrowserView.swift
//  PhotoFetcher-Browser
//
//  Created by Łukasz Bielawski on 16/08/2023.
//

import SwiftUI

struct PhotoBrowserView: View {
    var body: some View {
        CachedImage(url: "https://upload.wikimedia.org/wikipedia/en/9/9a/Trollface_non-free.png")
    }
}

struct PhotoBrowserView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoBrowserView()
    }
}
