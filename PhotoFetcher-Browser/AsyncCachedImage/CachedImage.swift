//
//  CachedImage.swift
//  PhotoFetcher-Browser
//
//  Created by Łukasz Bielawski on 16/08/2023.
//

import Foundation
import SwiftUI

struct CachedImage: View {
    @StateObject private var model = CachedImage.Model()
    let url: String

    var body: some View {
        ZStack {
            if let data = model.data,
               let image = UIImage(data: data) {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 200, height: 200)
                    .aspectRatio(contentMode: .fit)
            }
        }.task {
            await model.load(from: url)
        }
    }
}

struct CachedImage_Previews: PreviewProvider {
    static var previews: some View {
        CachedImage(url: "https://upload.wikimedia.org/wikipedia/en/9/9a/Trollface_non-free.png")
    }
}
