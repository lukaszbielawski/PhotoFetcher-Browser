//
//  PhotoBrowserViewModel.swift
//  PhotoFetcher-Browser
//
//  Created by Łukasz Bielawski on 17/08/2023.
//

import Combine
import Foundation
import SwiftUI

class PhotoBrowserViewModel: ObservableObject {
    @Published var imagesData: [ImageData] = []
    @Published var page: Int = 1

    private(set) var bag = CancellableBag()
    private let service: ImageService

    init(service: ImageService = NetworkImageSerivce()) {
        self.service = service
    }

    private let perPage = 30

    func loadFetchRequest() {
        service
            .fetchImagesData(page: page, perPage: perPage)
            .receive(on: DispatchQueue.main)
            .sink { res in
                switch res {
                case .failure(let error):
                    print(ImageError.otherError(error: error))
                default: break
                }
                print(res)
            } receiveValue: { [weak self] imagesData in
                self?.page += 1
                self?.imagesData += imagesData
            }.store(in: &bag)
    }
}
