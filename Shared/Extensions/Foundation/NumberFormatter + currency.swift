//
//  NumberFormatter + currency.swift
//  Rent Split
//
//  Created by The Northstar✨ System on 10/2/22.
//

import Foundation



public extension NumberFormatter {
    /// A number formatter for currency numbers, like `$5.00` or `£10`
    ///
    /// A currency code is a three-letter code that is, in most cases, composed of a region’s two-character Internet region code plus an extra character to denote the currency unit. For example, the currency code for the Australian dollar is “AUD”. Currency codes are based on the ISO 4217 standard.
    ///
    /// - Parameters:
    ///   - code:           _optional_ - The currency code of the currency to format nubmers in.
    ///                     Defaults to the current locale's currency code, or `"USD"` if that can't be found
    ///   - fractionDigits: _optional_ - How many digits should appear after the decimal point. Defaults to `0...2`
    static func currency(_ code: String, fractionDigits: ClosedRange<UInt8> = 0...2) -> Self {
        let result = Self()
        result.numberStyle = .currency
        result.isLenient = true
        result.currencyCode = code
        result.minimumFractionDigits = .init(fractionDigits.lowerBound)
        result.maximumFractionDigits = .init(fractionDigits.upperBound)
        return result
    }
    
    
    /// A number formatter for currency numbers, like `$5.00` or `£10`
    ///
    /// A currency code is a three-letter code that is, in most cases, composed of a region’s two-character Internet region code plus an extra character to denote the currency unit. For example, the currency code for the Australian dollar is “AUD”. Currency codes are based on the ISO 4217 standard.
    ///
    /// - Parameters:
    ///   - code:           _optional_ - The currency code of the currency to format nubmers in.
    ///                     Defaults to the current locale's currency code, or `"USD"` if that can't be found
    ///   - fractionDigits: _optional_ - How many digits should appear after the decimal point. Defaults to `0...2`
    static func currency(fractionDigits: ClosedRange<UInt8> = 0...2) -> Self {
        #if os(iOS)
        if #available(iOS 16, *) {
            return currency(Locale.current.currency?.identifier ?? "USD")
        }
        #endif
        
        return currency(Locale.current.currency?.identifier ?? "USD")
    }
}
