//
//  BottomNavigationDrawer.swift
//  Rent Split
//
//  Created by The Northstar✨ System on 2023-10-18.
//

import SwiftUI

import CollectionTools
import FunctionTools



private let eachLineItemHeight: CGFloat = 48
private let iconTextSpacing: CGFloat = 24
private let bottomBleed: CGFloat = 18
private let cardCornerRadius: CGFloat = 24
private let dragHandleSize = CGSize(width: 48, height: 4)



struct BottomNavigationDrawer: ViewModifier {
    
    @State
    private var frame: CGRect = .zero
    
    @State
    private var dragScrimOffset: CGFloat = 0
    
    var showDragHandle = true
    
    @Binding
    var isShowing: Bool
    
    @ArrayBuilder<NavigationDrawerItem>
    var content: Generator<[NavigationDrawerItem]>
    
    
    func body(content: Content) -> some View {
        content
        
        // MARK: Scrim
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
                    .transition(.opacity)
                
                    .opacity(isShowing ? 1 : 0)
                    .allowsHitTesting(isShowing)
                    .animation(.easeInOut, value: isShowing)
            }
        
        
        // MARK: Drawer
            .overlay(alignment: .bottom) {
                Raw(content: self.content(), showDragHandle: showDragHandle)
                    .squishyInteractiveDismiss(isShowing: $isShowing)
                    .offset(y: dragScrimOffset)
            }
    }
}



// MARK: - Raw drawer

private extension BottomNavigationDrawer {
    struct Raw: View {
        
        let content: [NavigationDrawerItem]
        
        let showDragHandle: Bool
        
        
        var body: some View {
            VStack(spacing: 0) {
                ForEach(content.indices, id: \.self) { index in
                    content[index]
                        .frame(minWidth: (eachLineItemHeight*2) + iconTextSpacing, maxWidth: .infinity,
                               minHeight: eachLineItemHeight,                      maxHeight: eachLineItemHeight)
                }
                //                                .border(Color.black)
            }
            .padding(.bottom, bottomBleed + dragHandlePadding)
//            .padding(.top, dragHandlePadding)
            .offset(y: bottomBleed + dragHandlePadding)
            .background {
                UnevenRoundedRectangle(
                    topLeadingRadius: cardCornerRadius,
                    topTrailingRadius: cardCornerRadius)
                .fill(Color(UIColor.systemBackground))
                .overlay(alignment: .top) {
                    if showDragHandle {
                        Capsule(style: .continuous)
                            .fill(.secondary.opacity(0.5))
                            .frame(width: dragHandleSize.width, height: dragHandleSize.height)
                            .padding(.top, dragHandlePadding / 2)
                    }
                }
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
        
        
        var dragHandlePadding: CGFloat {
            showDragHandle
                ? dragHandleSize.height * 3
                : 0
        }
    }
}



// MARK: - Public API

public extension View {
    func bottomNavigationDrawer(
        isShowing: Binding<Bool>,
        @ArrayBuilder<NavigationDrawerItem> content: @escaping Generator<[NavigationDrawerItem]>)
    -> some View {
        modifier(BottomNavigationDrawer(isShowing: isShowing, content: content))
    }
}



#Preview {
    Preview()
}



private struct Preview: View {
    
    @State
    var showDragHandle = true
    
    @State
    var isDrawerShowing = false
    
    var body: some View {
        Form {
            Toggle("Show drag handle", isOn: $showDragHandle)
            Button("Show nav drawer", action: { isDrawerShowing.toggle() })
            
            Group {
                Image(systemName: "circle.hexagongrid.fill")
                Image(systemName: "paintpalette.fill")
            }
            .font(.system(size: 256))
        }
        .symbolRenderingMode(.multicolor)
        .bottomNavigationDrawer(isShowing: $isDrawerShowing) {
            NavigationDrawerItem(
                title: "Top Item",
                icon: .init(systemImage: "arrow.up")) {}
            
            NavigationDrawerItem(
                title: "Mid Item",
                icon: .init(systemImage: "square.3.layers.3d.middle.filled", color: .accentColor)) {}
            
            NavigationDrawerItem(
                title: "Bottom Item",
                icon: .init(systemImage: "arrow.down.left")) {}
        }
//        .background(Color.accentColor.opacity(0.5))
    }
}
