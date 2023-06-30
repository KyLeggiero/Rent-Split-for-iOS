//
//  ContentView.swift
//  Rent Split
//
//  Created by The Northstar✨ System on 2022-07-07.
//

import SwiftUI
import SwiftData

import RentSplitTools



struct ContentView: View {
    
    @Query
    private var rentSplits: [RentSplitDataModel]
    
    @State
    private var currentSplitIndex: [RentSplitDataModel].Index = 0
    
    @State
    private var moneySplitter = MoneySplitter()
    
    @Environment(\.modelContext)
    private var modelContext
    
    
    var body: some View {
            AppBar(position: .bottom) {
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
            } label: {
//                Text("Rent Split")
//                    .font(.title.bold())
                Image("Logo_AppBar")
                    .resizable()
                    .scaledToFit()
            }
            .onAppear {
                currentSplitIndex = rentSplits.startIndex
            }
    }
}



#Preview {
    ContentView()
        .modelContainer(previewContainer)
}
