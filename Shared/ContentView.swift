//
//  ContentView.swift
//  Rent Split
//
//  Created by S🌟System on 2022-07-07.
//

import SwiftUI

import RentSplitTools



struct ContentView: View {
    
    @Environment(\.moneySplitter)
    private var moneySplitter: MoneySplitter
    
    
    var body: some View {
        AppBar(position: .bottom) {
            List {
                if case .disparateIncomes(roommates: let roommates, expenses: _) = moneySplitter.mode {
                    Section("Roommates") {
                        ForEach(roommates) { roommate in
                            HStack {
                                Text(roommate.roommate.name)
                            }
                        }
                    }
                }
                
                Section("Expenses") {
                    ForEach(moneySplitter.expenses) { expense in
                        HStack {
                            Text(expense.name)
                        }
                    }
                }
            }
        }
        label: {
//            Text("Rent Split")
//                .font(.title.bold())
            Image("Logo_AppBar")
                .resizable()
                .scaledToFit()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
