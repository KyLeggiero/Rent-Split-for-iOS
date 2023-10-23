//
//  NavigationDrawerItem.swift
//  Rent Split
//
//  Created by The Northstar✨ System on 2023-10-18.
//

import SwiftUI

import CollectionTools
import FunctionTools



public struct NavigationDrawerItem: View {
    
    let title: LocalizedStringKey
    
    let icon: Icon
    
    let action: BlindCallback
    
    
    public var body: some View {
        Button(action: action) {
            HStack(spacing: 24) {
                icon
                    .frame(minWidth: 48, minHeight: 48)
                
                Text(title)
                    .foregroundStyle(Color.primary)
                
                Spacer(minLength: 24)
            }
        }
    }
}



public extension NavigationDrawerItem {
    struct Icon: View {
        
        let image: Image
        
        var color: Color?
        
        
        public var body: some View {
            image
                .foregroundStyle(color ?? .primary)
        }
    }
}



public extension NavigationDrawerItem.Icon {
    init(systemImage: String, variableValue: Double? = nil, color: Color? = nil) {
        self.init(
            image: .init(systemName: systemImage, variableValue: variableValue),
            color: color)
    }
    
    
    init(imageName: String, color: Color? = nil) {
        self.init(
            image: .init(imageName),
            color: color)
    }
}



#Preview {
    VStack(spacing: 0) {
        NavigationDrawerItem(
            title: "Support",
            icon: .init(systemImage: "heart.fill", color: .red)) {
                print("Supported!")
            }
            .border(Color.red)
        NavigationDrawerItem(
            title: "Favorites",
            icon: .init(systemImage: "star")) {
                print("Supported!")
            }
            .border(Color.red)
    }
}
