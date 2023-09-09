//
//  PhotoSearchView.swift
//  PhotoFetcher-Browser
//
//  Created by Łukasz Bielawski on 07/09/2023.
//

import SwiftUI

struct PhotoSearchView: View {
    @StateObject var viewModel = PhotoSearchViewModel()

    var body: some View {
        ZStack(alignment: .top) {
            Color.primaryColor
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
            PhotoBrowserView(viewModel: viewModel.imageLoader)
                .onPreferenceChange(SearchViewHiddenPreferenceKey.self) { value in
                    if value {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            viewModel.isSearchBarHidden = value
                        }
                    } else {
                        viewModel.isSearchBarHidden = value
                    }
                }
                .offset(y: viewModel.isSearchBarHidden ? 0.0 : viewModel.searchBarHeight)
                .offset(y: viewModel.isSearchBarHidden ? 0.1 : 0.0)
                .animation(.easeInOut(duration: 0.5), value: viewModel.isSearchBarHidden)
            SearchBarView(query: $viewModel.imageLoader.query)
                .background(Color.primaryColor)
                .offset(y: viewModel.isSearchBarHidden ? -2 * viewModel.searchBarHeight : 0)
                .overlay(
                    GeometryReader { geo in
                        Color.clear
                            .onAppear {
                                viewModel.searchBarHeight = geo.size.height
                            }
                    }
                )
                .animation(.easeInOut(duration: 0.5), value: viewModel.isSearchBarHidden)
        }
        .onChange(of: viewModel.imageLoader.query) { _ in
            viewModel.search()
        }
    }
}

struct SearchViewHiddenPreferenceKey: PreferenceKey {
    static var defaultValue: Bool = false

    static func reduce(value: inout Bool, nextValue: () -> Bool) {
        value = nextValue()
    }
}

extension PhotoSearchView {
    struct SearchBarView: View {
        @Binding var query: String
        var body: some View {
            TextField("Type something; mountain, flowers, etc.", text: $query)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
        }
    }
}

struct PhotoSearchView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoSearchView(viewModel: PhotoSearchViewModel())
    }
}
