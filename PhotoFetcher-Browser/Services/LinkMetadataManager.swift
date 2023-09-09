//
//  LinkMetadataManager.swift
//  PhotoFetcher-Browser
//
//  Created by Łukasz Bielawski on 06/09/2023.
//

import LinkPresentation

final class LinkMetadataManager: NSObject, UIActivityItemSource {
    var linkMetadata: LPLinkMetadata
    let appTitle = Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String
    var url: String
    var iconUrl: String

    init(linkMetadata: LPLinkMetadata = LPLinkMetadata(), url: String, iconUrl: String) {
        self.linkMetadata = linkMetadata
        self.url = url
        self.iconUrl = iconUrl
    }
}

extension LinkMetadataManager {
    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        guard let url = URL(string: url) else { return linkMetadata }

        linkMetadata.originalURL = url
        linkMetadata.url = linkMetadata.originalURL
        linkMetadata.title = appTitle
        linkMetadata.imageProvider = NSItemProvider(
            contentsOf: URL(string: iconUrl))

        return linkMetadata
    }

    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return String()
    }

    func activityViewController(_ activityViewController: UIActivityViewController,
                                itemForActivityType activityType: UIActivity.ActivityType?) -> Any?
    {
        return linkMetadata.url
    }
}
