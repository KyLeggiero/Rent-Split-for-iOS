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
        List(moneySplitter.expenses) { expense in
            Text(expense.name)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
