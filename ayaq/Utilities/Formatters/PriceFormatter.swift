//
//  PriceFormatter.swift
//  ayaq
//
//  Created by Bakberdi Esentai on 14.12.2025.
//

import Foundation

struct PriceFormatter {
    
    private static let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        return formatter
    }()
    
    static func format(_ price: Decimal, currencyCode: String = "USD") -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currencyCode
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        return formatter.string(from: price as NSDecimalNumber) ?? "$\(price)"
    }
    
    static func format(_ price: Double, currencyCode: String = "USD") -> String {
        return format(Decimal(price), currencyCode: currencyCode)
    }
    
    static func formatSimple(_ price: Decimal) -> String {
        return String(format: "%.2f", NSDecimalNumber(decimal: price).doubleValue)
    }
    
    static func formatWithSymbol(_ price: Decimal, symbol: String = "$") -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.minimumFractionDigits = 2
        
        if let formattedNumber = numberFormatter.string(from: price as NSDecimalNumber) {
            return "\(symbol)\(formattedNumber)"
        }
        return "\(symbol)\(price)"
    }
    
    static func formatWithDiscount(original: Decimal, discounted: Decimal, currencyCode: String = "USD") -> String {
        let originalFormatted = format(original, currencyCode: currencyCode)
        let discountedFormatted = format(discounted, currencyCode: currencyCode)
        return "\(discountedFormatted) (was \(originalFormatted))"
    }
    
    static func calculateDiscount(original: Decimal, discounted: Decimal) -> String {
        guard original > 0 else { return "0%" }
        let discount = ((original - discounted) / original) * 100
        return String(format: "%.0f%%", NSDecimalNumber(decimal: discount).doubleValue)
    }
}

