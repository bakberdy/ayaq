//
//  CustomNumberFormatter.swift
//  ayaq
//
//  Created by Bakberdi Esentai on 14.12.2025.
//

import Foundation

struct CustomNumberFormatter {
    
    private static let decimalFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 0
        return formatter
    }()
    
    private static let percentFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 0
        formatter.minimumFractionDigits = 0
        return formatter
    }()
    
    static func formatDecimal(_ number: Double, fractionDigits: Int = 2) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = fractionDigits
        formatter.minimumFractionDigits = 0
        return formatter.string(from: NSNumber(value: number)) ?? "\(number)"
    }
    
    static func formatInteger(_ number: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: number)) ?? "\(number)"
    }
    
    static func formatWithSeparator(_ number: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: number)) ?? "\(number)"
    }
    
    static func formatPercent(_ value: Double, fractionDigits: Int = 0) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = fractionDigits
        formatter.minimumFractionDigits = 0
        return formatter.string(from: NSNumber(value: value)) ?? "\(value * 100)%"
    }
    
    static func formatRating(_ rating: Double) -> String {
        return String(format: "%.1f", rating)
    }
    
    static func formatCompact(_ number: Int) -> String {
        let thousand = 1000
        let million = 1000000
        let billion = 1000000000
        
        if number >= billion {
            return String(format: "%.1fB", Double(number) / Double(billion))
        } else if number >= million {
            return String(format: "%.1fM", Double(number) / Double(million))
        } else if number >= thousand {
            return String(format: "%.1fK", Double(number) / Double(thousand))
        } else {
            return "\(number)"
        }
    }
    
    static func formatOrdinal(_ number: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .ordinal
        return formatter.string(from: NSNumber(value: number)) ?? "\(number)"
    }
}

