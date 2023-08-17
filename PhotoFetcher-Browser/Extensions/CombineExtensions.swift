//
//  CombineExtensions.swift
//  PhotoFetcher-Browser
//
//  Created by Łukasz Bielawski on 17/08/2023.
//

import Combine
import Foundation

typealias CancellableBag = Set<AnyCancellable>

extension CancellableBag {
    mutating func clean() {
        self.forEach { $0.cancel() }
        self.removeAll()
    }
}
