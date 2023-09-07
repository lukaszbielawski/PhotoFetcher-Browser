//
//  PhotoBrowserViewModel.swift
//  PhotoFetcher-Browser
//
//  Created by Łukasz Bielawski on 17/08/2023.
//

import Combine
import Foundation
import SwiftUI

class ImageLoaderViewModel: ObservableObject {
    @Published var imagesData: [ImageData] = []
    @Published var query: String = ""
    @Published var favouritesChanged: Bool = false
    @Published var detailsPresented: Bool = false
    @Published var firstAppear: Bool = true

    var bag = CancellableBag()
    var service: ImageService
    var isFinite: Bool

    init(service: ImageService = FakeImageService(), isFinite: Bool = false) {
        self.service = service
        self.isFinite = isFinite
    }

    func loadFetchRequest(query: String) {
        service
            .fetchImagesData(query: query)
            .receive(on: DispatchQueue.main)
            .sink { res in
                switch res {
                case .failure(let error):
                    print(ImageError.otherError(error: error))
                default: break
                }
                print(res)
            } receiveValue: { [weak self] imagesData in
                if !(self?.isFinite ?? false) {
                    self?.imagesData += imagesData
                } else {
                    self?.imagesData = imagesData
                }
            }.store(in: &bag)
    }

    func resetData() {
        imagesData.removeAll()
        if type(of: service) == NetworkImageSerivce.self {
            (service as? NetworkImageSerivce)!.page = 0
        }
    }

    func storeImageInFavourites(image: ImageData) {
        let favouritesKey = "favourites"
        let userDefaults = UserDefaults.standard

        let encoder = JSONEncoder()
        guard let encodedImage = try? encoder.encode(image) else { return }

        userDefaults.set(encodedImage, forKey: image.slug)

        guard var array = userDefaults.array(forKey: favouritesKey) else {
            userDefaults.set([image.slug], forKey: favouritesKey)
            return
        }
        array.append(image.slug)
        userDefaults.removeObject(forKey: favouritesKey)
        userDefaults.set(array, forKey: favouritesKey)
    }

    func removeImageFromFavourites(image: ImageData) {
        let favouritesKey = "favourites"
        let userDefaults = UserDefaults.standard

        userDefaults.removeObject(forKey: image.slug)

        guard var array = userDefaults.array(forKey: favouritesKey) as? [String] else { return }
        array.removeAll(where: { $0 == image.slug })
        userDefaults.removeObject(forKey: favouritesKey)
        userDefaults.set(array, forKey: favouritesKey)
    }
}
