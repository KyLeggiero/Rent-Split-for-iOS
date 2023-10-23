//
//  EditMode + conveniences.swift
//  Rent Split
//
//  Created by The Northstar✨ System on 2023-10-11.
//

import SwiftUI



extension EditMode {
    
    @inline(__always)
    var isEditing: Bool {
        switch self {
        case .inactive:
            return false
            
        case .transient,
                .active:
            return true
            
        @unknown default:
            return false
        }
    }
}



extension Optional where Wrapped == EditMode {
    
    @inline(__always)
    var isEditing: Bool {
        switch self {
        case .none:
            return false
        case .some(let wrapped):
            return wrapped.isEditing
        }
    }
}



extension Binding where Value == EditMode {
    
    @inline(__always)
    var isEditing: Bool {
        wrappedValue.isEditing
    }
}



extension Optional where Wrapped == Binding<EditMode> {
    
    @inline(__always)
    var isEditing: Bool {
        switch self {
        case .none:
            return false
        case .some(let wrapped):
            return wrapped.isEditing
        }
    }
}



extension Binding where Value == Optional<EditMode> {
    
    @inline(__always)
    var isEditing: Bool {
        wrappedValue.isEditing
    }
}
