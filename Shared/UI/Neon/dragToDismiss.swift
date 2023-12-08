//
//  dragToDismiss.swift
//  Rent Split
//
//  Created by The Northstar✨ System on 2023-10-23.
//

import SwiftUI

import BasicMathTools
import RectangleTools



private struct InteractiveDragToDismiss: ViewModifier {
    
    var minimumDragDistanceBeforeGestureStarts: CGFloat = 1
    
    var dragDistanceToDismiss: CGFloat = 25
    
    var dragAxis: Axis = .vertical
    
    @Binding
    var dragDistance: CGFloat
    
    @Binding
    var isShowing: Bool
    
    
    func body(content: Content) -> some View {
        content
            .gesture(DragGesture(minimumDistance: minimumDragDistanceBeforeGestureStarts)
                .onChanged { value in
                    dragDistance = value.translation.distance(along: dragAxis)
                }
                .onEnded { value in
                    dragDistance = 0
                    
                    if abs(value.translation.distance(along: dragAxis)) > dragDistanceToDismiss {
                        isShowing = false
                    }
                }
            )
    }
}



private extension CGSize {
    func distance(along axis: Axis) -> CGFloat {
        switch axis {
        case .horizontal:
            return width
            
        case .vertical:
            return height
        }
    }
    
    
//    func distance(along axes: Axis.Set) -> CGFloat {
//        Axis
//            .allCases
//            .filter(axes.contains)
//            .map(distance)
//            .sum()
//    }
    
    
    /// The distance from any vertex of the size, to the point directly opposite of that
    var magnitude: CGFloat {
        minXminY().distance(to: maxXmaxY())
    }
}



private extension Axis.Set {
    
    init(_ axis: Axis) {
        switch axis {
        case .horizontal: self = .horizontal
        case .vertical:   self = .vertical
        }
    }
    
    
    func contains(_ axis: Axis) -> Bool {
        contains(Self(axis))
    }
    
    
    /// The constituent member axes in this set
    var axes: [Axis] {
        Axis.allCases.filter(contains)
    }
}



public extension View {
    /// Interactively dismisses this view.
    ///  
    /// - Note: This does not move or change this view. Instead, it just takes over the details about tracking the user's gesture to see if they dismissed the view,
    ///         and tells you how far the user has dragged this view.
    ///         You may use this information to move the view as desired.
    ///
    /// - Parameters:
    ///   - minimumDragDistanceBeforeGestureStarts: _optional_ - How far (in points) the user must drag before this gesture begins. Defaults to `1`
    ///   - dragDistanceToDismiss:                  _optional_ - How far (in points) the user must drag from the initial starting drag point, before this view is considered dismissed. Defaults to `25`
    ///   - dragAxis:                               _optional_ - Which direction the user is dragging this view when dismissing it. Other axes of drag will be ignored by this gesture
    ///   - dragDistance:                           _optional_ - The total distance the user has dragged this view during this gesture. Reset back to `0` when the gesture completes
    ///   - isShowing:                              The binding which says whether this view is currently showing. This function will automatically set this binding to `false` when the user dismisses this view
    func interactiveDragDismiss(
        minimumDragDistanceBeforeGestureStarts: CGFloat = 1,
        dragDistanceToDismiss: CGFloat = 25,
        dragAxis: Axis = .vertical,
        dragDistance: Binding<CGFloat> = .constant(.zero),
        isShowing: Binding<Bool>)
    -> some View {
        modifier(InteractiveDragToDismiss(
            minimumDragDistanceBeforeGestureStarts: minimumDragDistanceBeforeGestureStarts,
            dragDistanceToDismiss: dragDistanceToDismiss,
            dragDistance: dragDistance,
            isShowing: isShowing))
    }
}
