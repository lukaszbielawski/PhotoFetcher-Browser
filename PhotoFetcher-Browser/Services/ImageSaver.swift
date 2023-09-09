//
//  ImageSaver.swift
//  PhotoFetcher-Browser
//
//  Created by Łukasz Bielawski on 06/09/2023.
//

import Combine
import Foundation
import SwiftUI

class ImageSaver: NSObject {
    init(viewModel: PhotoDetailsViewModel) {
        self.viewModel = viewModel
    }

    @ObservedObject var viewModel: PhotoDetailsViewModel

    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.saveCompleted), nil)
    }

    @objc private func saveCompleted(_ image: UIImage,
                                     didFinishSavingWithError error: Error?,
                                     contextInfo: UnsafeRawPointer)
    {
        if error != nil {
            self.viewModel.state = .failure
            print("error storing image to photo album")
        } else {
            self.viewModel.state = .success
            let impactMed = UIImpactFeedbackGenerator(style: .medium)
            impactMed.impactOccurred()
        }
    }
}
