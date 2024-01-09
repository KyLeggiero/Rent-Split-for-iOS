//
//  MoneySplitChart.swift
//  Rent Split
//
//  Created by The Northstar✨ System on 2023-12-07.
//

import SwiftUI
import Charts

import RentSplitTools



private let innerRadiusRatio: CGFloat = 93.07/200



struct MoneySplitChart: View {
    
    let split: MoneySplitter
    
    
    var body: some View {
//        VStack {
//            Form {
//                ForEach(split.split.shares, id: \.id) { share in
//                    Text("\(share.debugDescription)")
//                        .foregroundStyle(share.person.color)
//                }
//            }
            
            Chart(split.split.shares, id: \.id) { share in
                SectorMark(angle: .value(share.person.name, share.expenseSum.monthly.money),
                           innerRadius: .ratio(innerRadiusRatio),
                           angularInset: 1)
                .foregroundStyle(share.person.color)
                
            }
            .chartOverlay { chartProxy in
                Group {
                    Image("Pie chart effects (shine; Plus Lighter)")
                        .resizable()
                        .blendMode(.plusLighter)
                    
                    Image("Pie chart effects (shadow; Plus Darker)")
                        .resizable()
                        .blendMode(.plusDarker)
                    
                    Image("Pie chart effects (highlight; Plus Lighter)")
                        .resizable()
                        .blendMode(.plusLighter)
                    
                    Image("Pie chart effects (edge shine; Plus Lighter)")
                        .resizable()
                        .blendMode(.plusLighter)
                }
                .aspectRatio(1, contentMode: .fit)
            }
            .clipShape(chartClipShape)
    }
    
    
    private var chartClipShape: some Shape {
        Circle()
            .subtracting(Circle().scale(innerRadiusRatio))
    }
}



extension CGFloat: Plottable {
    
    public typealias PrimitivePlottable = CGFloat.NativeType
    
    
    @inline(__always)
    public var primitivePlottable: PrimitivePlottable {
        native
    }
    
    
    @inline(__always)
    public init(primitivePlottable: PrimitivePlottable) {
        self.init(primitivePlottable)
    }
}



#Preview {
    MoneySplitChart(split: .demo)
}
