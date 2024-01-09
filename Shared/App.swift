//
//  App.swift
//  Rent Split
//
//  Created by The Northstar✨ System on 2022-07-07.
//

import SwiftUI
import SwiftData
import UniformTypeIdentifiers

import OptionalTools



@available(iOS 17.0, *)
@main
struct App: SwiftUI.App {
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }
        .modelContainer(for: RentSplitDataModel.self, inMemory: false, isAutosaveEnabled: true, isUndoEnabled: true)
    }
}



public extension UTType {
    static let rentSplit_iOS: Self = try! Self.init("org.bhstudios.rent-split.iOS-Save-Format").unwrappedOrThrow(error: NoSuchContentTypeError())
    
    
    
    private struct NoSuchContentTypeError: Error {}
}
