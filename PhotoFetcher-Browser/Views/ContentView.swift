//
//  ContentView.swift
//  PhotoFetcher-Browser
//
//  Created by Łukasz Bielawski on 16/08/2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            PhotoSearchView()
                .tabItem {
                    Label("Explore", systemImage: "globe.europe.africa.fill")
                }

            PhotoBrowserView(viewModel: ImageLoaderViewModel(service: FavouritesImageService(), isFinite: true))
                .tabItem {
                    Label("Liked", systemImage: "heart.fill")
                }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            UITabBar.appearance().scrollEdgeAppearance = UITabBarAppearance(idiom: .unspecified)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
