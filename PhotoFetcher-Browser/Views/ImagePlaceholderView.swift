//
//  ImagePlaceholderView.swift
//  PhotoFetcher-Browser
//
//  Created by Łukasz Bielawski on 17/08/2023.
//

import SwiftUI

struct ImagePlaceholderView: View {
    let geoWidth: CGFloat?

    var body: some View {
        ProgressView()
            .if(geoWidth != nil) { view in
                view.frame(width: geoWidth!, height: geoWidth!)
            }
            .background(Color.gray.cornerRadius(16))
    }
}
