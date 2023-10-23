//
//  GentleGeometryReader.swift
//  Rent Split
//
//  Created by The Northstar✨ System on 2023-10-21.
//

import SwiftUI



private struct GentleGeometryReader<Space: CoordinateSpaceWithGeometry>: ViewModifier {
    
    @Binding
    var geometry: Space.Geometry
    
    let coordinateSpace: Space
    
    
    func body(content: Content) -> some View {
        content
            .background {
                GeometryReader { geometryProxy in
                    Color
                        .clear
                        .allowsHitTesting(false)
                        .onChange(of: geometryProxy.frame(in: coordinateSpace), initial: true) { oldValue, newValue in
                            self.geometry = .init(from: geometryProxy, in: coordinateSpace)
                        }
                }
            }
    }
}



// MARK: - .API

public extension View {
    func gentleGeometryReader<Space>(
        geometry: Binding<Space.Geometry>,
        in coordinateSpace: Space)
    -> some View
        where Space: CoordinateSpaceWithGeometry
    {
        modifier(GentleGeometryReader(
            geometry: geometry,
            coordinateSpace: coordinateSpace))
    }
    
    
    @inline(__always)
    func gentleGeometryReader(
        geometry: Binding<GlobalCoordinateSpace.Geometry>)
    -> some View {
        gentleGeometryReader(geometry: geometry, in: .global)
    }
    
    
    func gentleGeometryReader<Space>(
        frame: Binding<CGRect>,
        in coordinateSpace: Space)
    -> some View
        where Space: CoordinateSpaceWithGeometry
    {
        var geometry = Space.Geometry.__zero
        
        return modifier(GentleGeometryReader(
            geometry: .init(
                get: { geometry },
                set: {
                    geometry = $0
                    frame.wrappedValue = geometry.frame
                }),
            coordinateSpace: coordinateSpace))
    }
    
    
    @inline(__always)
    func gentleGeometryReader(frame: Binding<CGRect>) -> some View {
        gentleGeometryReader(frame: frame, in: .global)
    }
}



// MARK: - Supporting types

public protocol GeometryProtocol {
    
    associatedtype Parent: CoordinateSpaceProtocol
    
    var frame: CGRect { get }
    
    var size: CGSize { get }
    
    var safeAreInsets: EdgeInsets { get }
    
    
    init(from geometryProxy: GeometryProxy, in coordinateSpace: Parent)
    
    
    /// **Unsupported:** An instance of this geometry with all values set to zero
    static var __zero: Self { get }
}



public protocol CoordinateSpaceWithGeometry: CoordinateSpaceProtocol {
    associatedtype Geometry: GeometryProtocol
        where Geometry.Parent == Self
}



extension LocalCoordinateSpace: CoordinateSpaceWithGeometry {
    public struct Geometry: GeometryProtocol {
        public let frame: CGRect
        public let size: CGSize
        public let safeAreInsets: EdgeInsets
        
        
        public init(from geometryProxy: GeometryProxy, in coordinateSpace: LocalCoordinateSpace) {
            frame = geometryProxy.frame(in: coordinateSpace)
            size = geometryProxy.size
            safeAreInsets = geometryProxy.safeAreaInsets
        }
        
        
        private init(frame: CGRect, size: CGSize, safeAreInsets: EdgeInsets) {
            self.frame = frame
            self.size = size
            self.safeAreInsets = safeAreInsets
        }
        
        
        public static var __zero: Self {
            Self.init(frame: .zero,
                      size: .zero,
                      safeAreInsets: .zero)
        }
    }
}



extension GlobalCoordinateSpace: CoordinateSpaceWithGeometry {
    public struct Geometry: GeometryProtocol {
        public let frame: CGRect
        public let size: CGSize
        public let safeAreInsets: EdgeInsets
        
        
        public init(from geometryProxy: GeometryProxy, in coordinateSpace: GlobalCoordinateSpace) {
            frame = geometryProxy.frame(in: coordinateSpace)
            size = geometryProxy.size
            safeAreInsets = geometryProxy.safeAreaInsets
        }
        
        
        private init(frame: CGRect, size: CGSize, safeAreInsets: EdgeInsets) {
            self.frame = frame
            self.size = size
            self.safeAreInsets = safeAreInsets
        }
        
        
        public static var __zero: Self {
            Self.init(frame: .zero,
                      size: .zero,
                      safeAreInsets: .zero)
        }
    }
}



extension NamedCoordinateSpace: CoordinateSpaceWithGeometry {
    public struct Geometry: GeometryProtocol {
        public let frame: CGRect
        public let size: CGSize
        public let bounds: CGRect?
        public let safeAreInsets: EdgeInsets
        
        
        public init(from geometryProxy: GeometryProxy, in coordinateSpace: NamedCoordinateSpace) {
            frame = geometryProxy.frame(in: coordinateSpace)
            size = geometryProxy.size
            safeAreInsets = geometryProxy.safeAreaInsets
            bounds = geometryProxy.bounds(of: coordinateSpace)
        }
        
        
        private init(frame: CGRect, size: CGSize, bounds: CGRect?, safeAreInsets: EdgeInsets) {
            self.frame = frame
            self.size = size
            self.bounds = bounds
            self.safeAreInsets = safeAreInsets
        }
        
        
        public static var __zero: Self {
            Self.init(frame: .zero,
                      size: .zero,
                      bounds: .zero,
                      safeAreInsets: .zero)
        }
    }
}



// MARK: - Preview

#Preview {
//    GentleGeometryReader
    Text("TODO")
}
