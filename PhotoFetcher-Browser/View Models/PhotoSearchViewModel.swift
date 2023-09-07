//
//  PhotoSearchViewModel.swift
//  PhotoFetcher-Browser
//
//  Created by Łukasz Bielawski on 07/09/2023.
//

import Combine
import Foundation

class PhotoSearchViewModel: ObservableObject {
    @Published var isSearchBarHidden = false
    @Published var searchBarHeight: CGFloat = .zero
    @Published var imageLoader: ImageLoaderViewModel

    var searchPhrase = PassthroughSubject<String, Never>()

    init() {
        let service = NetworkImageSerivce()
        self._imageLoader = Published(wrappedValue: ImageLoaderViewModel(service: service))
        setupImagesSubscribtion()
    }

    func search() {
        searchPhrase.send(imageLoader.query)
    }

    func setupImagesSubscribtion() {
        searchPhrase
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
            .compactMap { $0.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) }
            .sink { [weak self] query in
                self?.imageLoader.resetData()
                self?.imageLoader.loadFetchRequest(query: query)
            }.store(in: &imageLoader.bag)
    }
}

//    .addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
