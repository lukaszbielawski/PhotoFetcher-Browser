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
            PhotoBrowserView(imageLoader: ImageLoaderViewModel(service: NetworkImageSerivce()))
                .tabItem {
                    Label("Explore", systemImage: "globe.europe.africa.fill")
                }
            PhotoBrowserView(imageLoader: ImageLoaderViewModel(service: FavouritesImageService(), isFinite: true))
                .tabItem {
                    Label("Liked", systemImage: "heart.fill")
                }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            UITabBar.appearance().scrollEdgeAppearance = UITabBarAppearance.init(idiom: .unspecified)
        }
//        .onAppear {
//                        let defaults = UserDefaults.standard
//                        let dictionary = defaults.dictionaryRepresentation()
//                        dictionary.keys.forEach { key in
//                            defaults.removeObject(forKey: key)
//                        }
//        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
