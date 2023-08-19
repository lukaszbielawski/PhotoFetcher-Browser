//
//  ContentView.swift
//  PhotoFetcher-Browser
//
//  Created by Łukasz Bielawski on 16/08/2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
//        PhotoBrowserView(viewModel: PhotoBrowserViewModel(service: FakeImageService()))
        PhotoBrowserView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
