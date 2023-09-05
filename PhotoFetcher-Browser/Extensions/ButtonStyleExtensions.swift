//
//  ButtonStyleExtensions.swift
//  PhotoFetcher-Browser
//
//  Created by Łukasz Bielawski on 05/09/2023.
//

import Foundation
import SwiftUI

struct EmptyButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
    }
}

extension ButtonStyle where Self == EmptyButtonStyle {
    static var empty: EmptyButtonStyle { .init() }
}
