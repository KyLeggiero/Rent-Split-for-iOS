//
//  PersonColor + SwiftUI.swift
//  Rent Split
//
//  Created by The Northstar✨ System on 2023-12-11.
//

import SwiftUI

import RentSplitTools



extension PersonColor {
    @inline(__always)
    var color: Color {
        Color(nativeColor)
    }
}



extension PersonColor: ShapeStyle {
    public func resolve(in environment: EnvironmentValues) -> Color.Resolved { self.color.resolve(in: environment) }
}
