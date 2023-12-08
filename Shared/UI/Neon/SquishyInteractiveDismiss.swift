//
//  SquishyInteractiveDismiss.swift
//  Rent Split
//
//  Created by The Northstar✨ System on 2023-10-23.
//

import SwiftUI



private struct SquishyInteractiveDismiss: ViewModifier {
    
    @State
    private var dragScrimOffset: CGFloat = .zero
    
    @State
    private var frame: CGRect = .zero
    
    let minDragToDismiss: (upward: CGFloat, downward: CGFloat) = (upward: 100, downward: 48)
    
    @Binding
    var isShowing: Bool
    
    
    func body(content: Content) -> some View {
        content
            .gentleGeometryReader(frame: $frame)
            .offset(x: 0, y: isShowing ? 0 : frame.height * 2)
            .opacity(isShowing ? 1 : 0)
            .animation(.spring.speed(2), value: isShowing)
            .offset(y: max(0, dragScrimOffset))
            .transformEffect(
                .identity
                    .scaledBy(
                        x: 1,
                        y: dragScrimOffset < 0
                            ? stretch(dragOffset: -dragScrimOffset.animatableData)
                            : 1)
                    .translatedBy(
                        x: 0,
                        y: dragScrimOffset < 0
                            ? (frame.height * (1-stretch(dragOffset: -dragScrimOffset.animatableData)))
                            : 0)
            )
            .highPriorityGesture(DragGesture(minimumDistance: 10)
                .onChanged { value in
                    dragScrimOffset.animatableData = value.translation.height
                }
                .onEnded { value in
                    dragScrimOffset.animatableData = 0
                    
                    if value.translation.height > abs(minDragToDismiss.downward)
                        || value.translation.height < -abs(minDragToDismiss.upward)
                    {
                        isShowing = false
                    }
                }
            )
            .animation(.spring, value: dragScrimOffset)
//            .animation(.easeOut, value: isShowing)
    }
}



/// A number between 1 and 1.25, denoting the amount by which the bottom drawer stretches when dragged
/// - Parameter dragOffset: The distance that the user has dragged so far. **Must be positive!**
/// - Returns: The percentage by which the target view should be stretched
@inline(__always)
private func stretch(dragOffset: CGFloat) -> CGFloat {
    // https://www.wolframalpha.com/input?i=Plot%5B-1%2F%280.01+x+%2B+1%29%2F4+%2B+1.25%2C+%7Bx%2C+0%2C+1000%7D%2C+%7By%2C+1%2C+1.25%7D%5D
    ((-1 / ((0.01 * dragOffset) + 1)) / 4) + 1.25
}



public extension View {
    
    /// Allows this view to be dismissed in a way that makes it squish and stretch
    /// - Parameter isShowing: <#isShowing description#>
    /// - Returns: <#description#>
    func squishyInteractiveDismiss(isShowing: Binding<Bool>) -> some View {
        modifier(SquishyInteractiveDismiss(isShowing: isShowing))
    }
}



#Preview {
    AppBar {
        List {
            Text("Wheeee")
        }
    } drawer: {
        NavigationDrawerItem(title: "Item One", icon: .init(systemImage: "1.circle"), action: {})
        NavigationDrawerItem(title: "Item Two", icon: .init(systemImage: "2.circle"), action: {})
        NavigationDrawerItem(title: "Item Three", icon: .init(systemImage: "3.circle"), action: {})
    }
}
