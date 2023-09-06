//
//  PhotoDetailsViewModel.swift
//  PhotoFetcher-Browser
//
//  Created by Łukasz Bielawski on 06/09/2023.
//

import Combine
import Foundation
import SwiftUI

class PhotoDetailsViewModel: ObservableObject {
    @Published var isFavourite: Bool
    @Published var state: ImageDownloadState

    @Published var isHearted: Bool = false {
        didSet {
            guard isHearted else { return }

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.125) {
                self.isHearted = false
            }
        }
    }

    let imageData: ImageData
    var imageSaver: ImageSaver?
    var service: ImageFetcherService = .init()
    private(set) var bag = CancellableBag()

    init(imageData: ImageData) {
        self.imageData = imageData
        self._state = Published(wrappedValue: .nan)
        self._isFavourite = Published(wrappedValue: FavouritesManager.isAlreadyFavourite(imageData: imageData))
        self.imageSaver = ImageSaver(viewModel: self)
    }

    func downloadAndStoreImageFromUrl(url: URL) {
        state = .loading
        bag.clean()
        service
            .fetchImageFromUrl(url: url)
            .sink { [weak self] res in
                switch res {
                case .failure(let error):
                    self?.state = .failure
                    print(ImageError.otherError(error: error))
                default: break
                }
            } receiveValue: { [weak self] image in
                self?.imageSaver!.writeToPhotoAlbum(image: image)
            }
            .store(in: &bag)
    }
}
