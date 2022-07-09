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
        static var defaultValue = MoneySplitter(mode: .disparateIncomes)
    }
}



public extension EnvironmentValues {
    
    var moneySplitter: MoneySplitter {
        get { self[MoneySplitter.Key.self] }
        set { self[MoneySplitter.Key.self] = newValue }
    }
}
