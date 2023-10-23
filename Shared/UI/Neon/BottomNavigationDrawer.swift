//
//  BottomNavigationDrawer.swift
//  Rent Split
//
//  Created by The Northstar✨ System on 2023-10-18.
//

import SwiftUI

import CollectionTools
import FunctionTools



private let bottomBleed: CGFloat = 18
private let cardCornerRadius: CGFloat = 24



struct BottomNavigationDrawer: ViewModifier {
    
    @State
    private var frame: CGRect = .zero
    
    @State
    private var dragScrimOffset: CGFloat = 0
    
    @Binding
    var isShowing: Bool
    
    @ArrayBuilder<NavigationDrawerItem>
    var content: Generator<[NavigationDrawerItem]>
    
    
    func body(content: Content) -> some View {
        content
            .overlay {
                Rectangle()
//                    .fill(Color.gray)
//                    .blendMode(.multiply)
                    .environment(\.colorScheme, .light) // light color scheme = dark scrim
                    .background(.ultraThinMaterial)
                    .ignoresSafeArea()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .onTapGesture {
                        isShowing = false
                    }
                    .gesture(DragGesture(minimumDistance: 10)
                        .onChanged { value in
                            dragScrimOffset = value.translation.height
                        }
                        .onEnded { value in
                            dragScrimOffset = 0
                            
                            if abs(value.translation.height) > 25 {
                                isShowing = false
                            }
                        }
                    )
                    .transition(.opacity)
                
                    .opacity(isShowing ? 1 : 0)
                    .allowsHitTesting(isShowing)
                    .animation(.easeInOut, value: isShowing)
            }
        
        
            .overlay(alignment: .bottom) {
                Raw(content: self.content())
                    .gentleGeometryReader(frame: $frame)
                    .offset(x: 0, y: isShowing ? 0 : frame.height * 2)
                    .opacity(isShowing ? 1 : 0)
                    .animation(.bouncy, value: isShowing)
                    .offset(y: max(0, dragScrimOffset))
                    .transformEffect(
                        .init(scaleX: 1,
                              y: dragScrimOffset < 0 ? stretch(dragOffset: -dragScrimOffset) : 1)
                        .translatedBy(x: 0,
                                      y: dragScrimOffset < 0 ? -stretch(dragOffset: -dragScrimOffset) : 1)
                    )
                    .animation(.easeOut, value: dragScrimOffset)
            }
    }
}



private func stretch(dragOffset: CGFloat) -> CGFloat {
    // https://www.wolframalpha.com/input?i=Plot%5B-1%2F%280.01+x+%2B+1%29%2F4+%2B+1.25%2C+%7Bx%2C+0%2C+1000%7D%2C+%7By%2C+1%2C+1.25%7D%5D
    ((-1 / ((0.01 * dragOffset) + 1)) / 4) + 1.25
}



private extension BottomNavigationDrawer {
    struct Raw: View {
        
        let content: [NavigationDrawerItem]
        
        var body: some View {
            VStack(spacing: 0) {
                ForEach(content.indices, id: \.self) { index in
                    content[index]
                        .frame(minWidth: 48 + 24 + 48, maxWidth: .infinity,
                               minHeight: 48,          maxHeight: 48)
                }
                //                                .border(Color.black)
            }
            .padding(.bottom, bottomBleed)
            .offset(y: bottomBleed)
            .background {
                UnevenRoundedRectangle(
                    topLeadingRadius: cardCornerRadius,
                    topTrailingRadius: cardCornerRadius)
                .fill(Color(UIColor.systemBackground))
                .offset(y: bottomBleed)
                //                                .frame(minWidth: 200, maxWidth: .infinity,
                //                                       minHeight: 64, maxHeight: .infinity)
                //                                .fixedSize(horizontal: false, vertical: true)
                //                        .overlay(alignment: .topLeading) {
                //                            Button("Close", systemImage: "xmark") {
                //                                isShowing = false
                //                            }
                //                            .padding(10)
                //                        }
                .material(elevation: 4)
//                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
//            .transition(.move(edge: .bottom).combined(with: .opacity))
        }
    }
}



#Preview {
    Preview()
}



private struct Preview: View {
    
    @State
    private var isShowing = true
    
    var body: some View {
        AppBar {
            Form {
                Toggle("Show", isOn: $isShowing.animation(.bouncy))
                Image(systemName: "circle.hexagongrid.fill")
                        .symbolRenderingMode(.multicolor)
                        .font(.system(size: 256))
                
                Image(systemName: "paintpalette.fill")
                        .symbolRenderingMode(.multicolor)
                        .font(.system(size: 256))
            }
            .modifier(BottomNavigationDrawer(isShowing: $isShowing) {
                NavigationDrawerItem(
                    title: "Top Item",
                    icon: .init(systemImage: "arrow.up")) {}
                
                NavigationDrawerItem(
                    title: "Mid Item",
                    icon: .init(systemImage: "square.3.layers.3d.middle.filled", color: .accentColor)) {}
                
                NavigationDrawerItem(
                    title: "Bottom Item",
                    icon: .init(systemImage: "arrow.down.left")) {}
            })
        } label: {
            Button("Drawer") {
                isShowing.toggle()
            }
            .foregroundStyle(.primary)
        }
//        .background(Color.accentColor.opacity(0.5))
    }
}
