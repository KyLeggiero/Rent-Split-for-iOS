//
//  Better initializer ordering.swift
//  Rent Split
//
//  Created by The Northstar✨ System on 10/29/22.
//

import SwiftUI



public extension Section where Parent : View, Content : View, Footer : View {
    init(header: @escaping () -> Parent, content: @escaping () -> Content, footer: @escaping () -> Footer) {
        self.init(content: content, header: header, footer: footer)
    }
}
