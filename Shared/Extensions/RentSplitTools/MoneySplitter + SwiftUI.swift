//
//  MoneySplitter + SwiftUI.swift
//  Rent Split (iOS)
//
//  Created by S🌟System on 2022-07-09.
//

import Foundation
import SwiftUI

import RentSplitTools




private extension MoneySplitter {
    struct Key: SwiftUI.EnvironmentKey {
        private static let holder = Holder()
        
        static let defaultValue = holder.$moneySplitter
        
        
        private struct Holder {
            @State
            var moneySplitter = MoneySplitter()
        }
    }
}



public extension EnvironmentValues {
    
    var moneySplitter: Binding<MoneySplitter> {
        get { self[MoneySplitter.Key.self] }
        set { self[MoneySplitter.Key.self] = newValue }
    }
}
