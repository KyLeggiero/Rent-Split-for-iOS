//
//  RentSplitDataModel.swift
//  Rent Split
//
//  Created by The Northstar✨ System on 2023-06-16.
//

import CoreTransferable
import Foundation
import SwiftData

import AppUniqueIdentifier
import RentSplitTools
import SerializationTools



@Model
public final class RentSplitDataModel {
    
    public var moneySplitter: MoneySplitter
    
    
    init(_ moneySplitter: MoneySplitter = .init()) {
        self.moneySplitter = moneySplitter
    }
}



// MARK: - Codable

private extension RentSplitDataModel {
    enum CodingKey: String, Swift.CodingKey {
        case moneySplitter
    }
}



extension RentSplitDataModel: Codable {
    
    public convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKey.self)
        self.init(try container.decode(MoneySplitter.self, forKey: .moneySplitter))
    }
    
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKey.self)
        try container.encode(moneySplitter, forKey: .moneySplitter)
    }
}



// MARK: - Transferable

extension RentSplitDataModel: Transferable {
    public static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(contentType: .json) { moneySplit in
            try moneySplit.jsonData()
        } importing: { splitData in
            try RentSplitDataModel(MoneySplitter(jsonData: splitData))
        }
    }
}
