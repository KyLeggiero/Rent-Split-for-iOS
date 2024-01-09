//
//  View + Material Elevation.swift
//  Rent Split (iOS)
//
//  Created by The Northstar✨ System on 2022-07-10.
//

import Foundation
import SwiftUI



// MARK: - Private Implementations

/// Implements a Material-style shadow as a modifier for SwiftUI views
private struct MaterialElevation: ViewModifier {
    
    let config: Shadow
    
    init(atElevation elevation: UInt8) {
        self.config = .init(atElevation: elevation)
    }
    
    func body(content: Content) -> some View {
        content
            .shadow(color: config.ambient.color,
                    radius: config.ambient.radius,
                    x: config.ambient.x,
                    y: config.ambient.y)
            .shadow(color: config.penumbra.color,
                    radius: config.penumbra.radius,
                    x: config.penumbra.x,
                    y: config.penumbra.y)
            .shadow(color: config.umbra.color,
                    radius: config.umbra.radius,
                    x: config.umbra.x,
                    y: config.umbra.y)
            .animation(.easeInOut, value: config)
    }
}


// MARK: Shadow structures

private let umbraColor = Color.black.opacity(0.14)
private let penumbraColor = Color.black.opacity(0.12)
private let ambientColor = Color.black.opacity(0.20)



private extension MaterialElevation {
    struct Shadow: Equatable {
        let umbra: Component
        let penumbra: Component
        let ambient: Component
        
        
        init(umbra: PartialComponent,
             penumbra: PartialComponent,
             ambient: PartialComponent) {
            self.umbra = .init(color: umbraColor, radius: umbra.radius, spread: umbra.spread, x: 0, y: umbra.y)
            self.penumbra = .init(color: penumbraColor, radius: penumbra.radius, spread: penumbra.spread, x: 0, y: penumbra.y)
            self.ambient = .init(color: ambientColor, radius: ambient.radius, spread: ambient.spread, x: 0, y: ambient.y)
        }
        
        
        typealias PartialComponent = (y: CGFloat, radius: CGFloat, spread: CGFloat)
    }
}



extension MaterialElevation.Shadow {
    struct Component: Equatable {
        let color: Color
        let radius: CGFloat
        let spread: CGFloat
        let x: CGFloat
        let y: CGFloat
    }
}


// MARK: Create an elevation from an UInt8

private extension MaterialElevation.Shadow {
    static let elevation24 = Self(umbra: PartialComponent(y: 24, radius: 38, spread: 3),
                                  penumbra: PartialComponent(y: 9, radius: 46, spread: 8),
                                  ambient: PartialComponent(y: 11, radius: 15, spread: 0))
    
    static let elevation16 = Self(umbra: PartialComponent(y: 16, radius: 24, spread: 2),
                                  penumbra: PartialComponent(y: 6, radius: 30, spread: 5),
                                  ambient: PartialComponent(y: 8, radius: 10, spread: 0))
    
    static let elevation12 = Self(umbra: PartialComponent(y: 12, radius: 17, spread: 2),
                                  penumbra: PartialComponent(y: 5, radius: 22, spread: 4),
                                  ambient: PartialComponent(y: 7, radius: 8, spread: 0))
    
    static let elevation9 = Self(umbra: PartialComponent(y: 9, radius: 12, spread: 1),
                                 penumbra: PartialComponent(y: 3, radius: 16, spread: 2),
                                 ambient: PartialComponent(y: 5, radius: 6, spread: 0))
    
    static let elevation8 = Self(umbra: PartialComponent(y: 8, radius: 10, spread: 1),
                                 penumbra: PartialComponent(y: 3, radius: 14, spread: 3),
                                 ambient: PartialComponent(y: 4, radius: 6, spread: 0))
    
    static let elevation6 = Self(umbra: PartialComponent(y: 6, radius: 10, spread: 0),
                                 penumbra: PartialComponent(y: 1, radius: 18, spread: 0),
                                 ambient: PartialComponent(y: 3, radius: 5, spread: 0))
    
    static let elevation4 = Self(umbra: PartialComponent(y: 2, radius: 4, spread: 0),
                                 penumbra: PartialComponent(y: 4, radius: 5, spread: 0),
                                 ambient: PartialComponent(y: 1, radius: 10, spread: 0))
    
    static let elevation3 = Self(umbra: PartialComponent(y: 3, radius: 3, spread: 0),
                                 penumbra: PartialComponent(y: 3, radius: 4, spread: 0),
                                 ambient: PartialComponent(y: 1, radius: 8, spread: 0))
    
    static let elevation2 = Self(umbra: PartialComponent(y: 0, radius: 4, spread: 0),
                                 penumbra: PartialComponent(y: 3, radius: 4, spread: 0),
                                 ambient: PartialComponent(y: 1, radius: 5, spread: 0))
    
    static let elevation1 = Self(umbra: PartialComponent(y: 0, radius: 2, spread: 0),
                                 penumbra: PartialComponent(y: 2, radius: 2, spread: 0),
                                 ambient: PartialComponent(y: 1, radius: 3, spread: 0))
    
    static let elevation0 = Self(umbra: PartialComponent(y: 0, radius: 0, spread: 0),
                                 penumbra: PartialComponent(y: 0, radius: 0, spread: 0),
                                 ambient: PartialComponent(y: 0, radius: 0, spread: 0))
    
    
    init(atElevation elevation: UInt8) {
        switch elevation {
        case 24...:
            self = .elevation24
            
        case 16..<24:
            self = .elevation16
            
        case 12..<16:
            self = .elevation12
            
        case 9..<12:
            self = .elevation9
            
        case 8..<9:
            self = .elevation8
            
        case 6..<8:
            self = .elevation6
            
        case 4..<6:
            self = .elevation4
            
        case 3..<4:
            self = .elevation3
            
        case 2..<3:
            self = .elevation2
            
        case 1..<2:
            self = .elevation1
            
        default:
            self = .elevation0
        }
    }
}



public extension View {
    
    /// Applies a Material-style elevation to this view
    /// - Parameter elevation: The amount of elecation to apply. While all values are valid, some might result in identical shadows to others
    @ViewBuilder
    func material(elevation: UInt8) -> some View {
        modifier(MaterialElevation(atElevation: elevation))
    }
}



private struct MaterialPreview: View {
    
    @Environment(\.colorScheme)
    private var colorScheme
    
    @State
    private var elevation: CGFloat = 4
    
    var body: some View {
        Form {
            RoundedRectangle(cornerRadius: 25.0)
                .fill(colorScheme == .dark
                      ? Color(.sRGB, red: 38/255, green: 50/255, blue: 56/255)
                      : Color(.sRGB, red: 0, green: 188/255, blue: 212/255))
                .frame(width: 200, height: 200)
                .material(elevation: .init(elevation))
                .overlay {
                    
                    Text("\(UInt8(elevation))")
                        .font(.largeTitle.monospacedDigit().weight(.black))
                    
                    VStack {
                        Spacer()
                        
                        let shadow = MaterialElevation.Shadow(atElevation: UInt8(elevation))
                        Text(verbatim: shadow.debugDescription)
                            .font(.caption2.monospacedDigit())
                            .foregroundStyle(.secondary)
                            .padding(.vertical, 8)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.vertical, 100)
            
            Slider(value: $elevation, in: 0 ... 24, step: 1) {
                Label("\(UInt8(elevation))", systemImage: "heart")
            } minimumValueLabel: {
                Text("0")
            } maximumValueLabel: {
                Text("24")
            }
        }
    }
}



extension MaterialElevation.Shadow: CustomDebugStringConvertible {
    var debugDescription: String {
        """
        Umbra: \(umbra)
        Penumbra: \(penumbra)
        Ambient: \(ambient)
        """
    }
}



extension MaterialElevation.Shadow.Component: CustomDebugStringConvertible {
    var debugDescription: String {
        "{y: \(UInt(y)), blur: \(UInt(radius)), spread: \(UInt(spread))}"
    }
}



#Preview {
    MaterialPreview()
}
