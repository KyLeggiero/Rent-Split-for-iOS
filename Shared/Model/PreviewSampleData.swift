//
//  PreviewSampleData.swift
//  Rent Split
//
//  Created by The Northstar✨ System on 2022-07-07.
//

import SwiftData

@MainActor
let previewContainer: ModelContainer = {
    let container = try! ModelContainer(
        for: RentSplitDataModel.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    for split in SampleSplits.allCases {
        container.mainContext.insert(split)
    }
    return container
}()
