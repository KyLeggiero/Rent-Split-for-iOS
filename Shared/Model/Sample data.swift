//
//  SampleSplits.swift
//  Rent Split
//
//  Created by The Northstar✨ System on 2023-06-27.
//

import Foundation

import RentSplitTools



public enum SampleSplits {
    static var allCases: [RentSplitDataModel] = [
        new,
        readme,
    ]
    
    
    static let new = RentSplitDataModel()
    
    /// The data model presented in public example screenshots and READMEs
    static let readme = RentSplitDataModel(MoneySplitter(
        people: [
            .tracyMinnett,
            .samAbrams,
            .isiMockta,
            .alexGibbs,
        ],
        roommates: [
            .init(id: Person.tracyMinnett.id, funding: .income(1234.56 / .month)),
            .init(id: Person.samAbrams.id, funding: .income(567.89 / .month)),
            .init(id: Person.isiMockta.id, funding: .income(2345.67 / .month)),
            .init(id: Person.alexGibbs.id, funding: .income(3456.78 / .month)),
        ],
        expenses: [
            .rent,
            .utilities,
            .internet,
            .phone,
        ]
    ))
}



private extension Person {
    static let tracyMinnett = Self(name: "Tracy Minnett")
    static let samAbrams = Self(name: "Sam Abrams")
    static let isiMockta = Self(name: "Isi Mockta")
    static let alexGibbs = Self(name: "Alex Gibbs")
}



private extension Expense {
    static let rent = Self(name: "Rent", rate: 1200 / .month)
    static let utilities = Self(name: "Utilities", rate: 75.42 / .month)
    static let internet = Self(name: "Internet", rate: 50 / .month)
    static let phone = Self(name: "Phone", rate: 40 / .month, participantIds: [
        Person.samAbrams.id,
        Person.alexGibbs.id
    ])
}
