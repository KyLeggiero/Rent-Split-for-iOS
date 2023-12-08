//
//  ContentView.swift
//  Rent Split
//
//  Created by The Northstar✨ System on 2022-07-07.
//

import SwiftUI
import SwiftData

import Introspection
import RentSplitTools



let repoUrl = URL(string: "https://github.com/BlueHuskyStudios/Rent-Split")!
let bugReportUrl = URL(string: "https://github.com/BlueHuskyStudios/Rent-Split/issues/new/choose")!
let supportUrl = URL(string: "https://github.com/sponsors/KyLeggiero")!



struct ContentView: View {
    
    @Query
    private var rentSplits: [RentSplitDataModel]
    
    @State
    private var currentSplitIndex: [RentSplitDataModel].Index = 0
    
    @State
    private var moneySplitter = MoneySplitter()
    
    @Environment(\.modelContext)
    private var modelContext
    
    @State
    private var isDrawerShowing = false
    
    
    var body: some View {
            AppBar(position: .bottom, showDrawer: $isDrawerShowing) {
                if rentSplits.indices.contains(currentSplitIndex) {
                    MoneySplitView(moneySplitter: .init(
                        get: { rentSplits[currentSplitIndex].moneySplitter },
                        set: { rentSplits[currentSplitIndex].moneySplitter = $0 }))
                }
                else {
                    VStack {
                        Text("No split chosen")
                        
                        Button {
                            modelContext.insert(RentSplitDataModel())
                        } label: {
                            Text("Create a new one")
                        }
                        
                        if currentSplitIndex != rentSplits.startIndex {
                            Button {
                                currentSplitIndex = rentSplits.startIndex
                            } label: {
                                Text("Select the first one")
                            }
                        }
                    }
                }
            } title: {
                HStack {
                    Image("Logo_AppBar")
                        .resizable()
                        .scaledToFit()
                        .zIndex(1)
                    
                    if isDrawerShowing {
                        Text(Introspection.appVersion.description)
                            .font(.system(size: 24, weight: .black))
                            .foregroundStyle(.white.opacity(0.5))
                            .zIndex(0)
                            .transition(.move(edge: .leading).combined(with: .opacity))
                    }
                }
                .animation(.easeInOut, value: isDrawerShowing)
            } accessory: {
                ShareLink(items: rentSplits, subject: Text("Subjective"), message: Text("Massage")) { model in
                    SharePreview("Rent Splits")
                } label: {
                    Label("Export", systemImage: "square.and.arrow.up")
                        .padding()
                }
                .foregroundStyle(.primary)
            } drawer: {
                NavigationDrawerItem(title: "Open another split", icon: .init(systemImage: "folder")) {
                    // TODO: How do We handle this?
                }
                
                NavigationDrawerItem(title: "Source code & license", icon: .init(systemImage: "chevron.left.forwardslash.chevron.right")) {
                    #if canImport(UIKit)
                        UIApplication.shared.open(repoUrl)
                    #elseif canImport(AppKit)
                        NSWorkspace.something.something.open(repoUrl)
                    #endif
                }
                
                NavigationDrawerItem(title: "Report a bug or request a feature", icon: .init(systemImage: "ladybug.fill")) {
                    #if canImport(UIKit)
                        UIApplication.shared.open(bugReportUrl)
                    #elseif canImport(AppKit)
                        NSWorkspace.something.something.open(bugReportUrl)
                    #endif
                }
                
                NavigationDrawerItem(title: "Support", icon: .init(systemImage: "heart.fill", color: .accentColor)) {
                    #if canImport(UIKit)
                        UIApplication.shared.open(supportUrl)
                    #elseif canImport(AppKit)
                        NSWorkspace.something.something.open(supportUrl)
                    #endif
                }
            }
            .onAppear {
                if rentSplits.isEmpty {
                    modelContext.insert(RentSplitDataModel())
                }
                
                currentSplitIndex = rentSplits.startIndex
            }
    }
}



#Preview {
    ContentView()
        .modelContainer(previewContainer)
}
