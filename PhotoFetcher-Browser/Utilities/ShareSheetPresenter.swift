//
//  ShareSheetPresenter.swift
//  PhotoFetcher-Browser
//
//  Created by Łukasz Bielawski on 06/09/2023.
//

import Foundation
import SwiftUI

struct ShareSheetPresenter {
    private init() {}

    static func showShareSheet(url: String, iconUrl: String) {
        guard let source = UIApplication.shared.windows.first?.rootViewController else {
            return
        }

        let activityItemMetadata = LinkMetadataManager(url: url, iconUrl: iconUrl)

        let activityVC = UIActivityViewController(
            activityItems: [activityItemMetadata],
            applicationActivities: nil)

        if let popoverController = activityVC.popoverPresentationController {
            popoverController.sourceView = source.view
            popoverController.permittedArrowDirections = []
            popoverController.sourceRect = CGRect(x: source.view.bounds.midX,
                                                  y: source.view.bounds.midY,
                                                  width: .zero, height: .zero)
        }
        source.present(activityVC, animated: true)
    }
}
