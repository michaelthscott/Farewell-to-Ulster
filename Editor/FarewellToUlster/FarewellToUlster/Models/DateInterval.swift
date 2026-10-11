//
//  DateInterval.swift
//  FarewellToUlster
//
//  Created by Michael Scott on 13/05/2026.
//

import Foundation

/// Extension of DateInterval to enable the interval to be considered as partially closed interval \[start, end\). The period does not include the day of the end date.
extension DateInterval {
    private static let secondsInADay: TimeInterval = 86400.00
    
    /// The time unit used to increment and decrement the interval.
    enum Unit: String, RawRepresentable, CaseIterable, Identifiable {
        case day
        case week
        case year
        
        var id: String {
            rawValue
        }
    }
    
    /// The number of days in the interval.
    var days: Int {
        guard duration > DateInterval.secondsInADay else { return 1 }
        return Int(duration / DateInterval.secondsInADay)
    }
    
    /// A string representation of the period that the interval covers.
    var periodDescription: String {
        switch days {
        case 1: return start.formatted(date: .abbreviated, time: .omitted)
        default: return start.formatted(date: .abbreviated, time: .omitted) + " - " + (end - DateInterval.secondsInADay).formatted(date: .abbreviated, time: .omitted)
        }
    }
    
    /// Increment the interval by the specified unit.
    /// - Parameter unit: the unit to incriment by.
    mutating func increment(by unit: Unit) {
        switch unit {
        case .day:
            updateDuration(by: 1)
        case .week:
            updateDuration(by: 7)
        case .year:
            updateDuration(by: end.nextYear.daysInYear)
        }
    }
    
    /// Decrement the interval by the specified unit.
    /// - Parameter unit: the unit to decrement by.
    mutating func decrement(by unit: Unit) {
        switch unit {
        case .day:
            updateDuration(by: -1)
        case .week:
            updateDuration(by: -7)
        case .year:
            updateDuration(by: -(end.previousYear.daysInYear))
        }
    }
    
    mutating private func updateDuration(by days: Int) {
        if days < 0 {
            duration = max(duration + TimeInterval(days) * DateInterval.secondsInADay, DateInterval.secondsInADay)
        } else if days > 0 {
            duration += TimeInterval(days) * DateInterval.secondsInADay
        }
    }
}

extension Date {
    /// The year containing the date.
    var year: Int {
        Calendar.current.component(.year, from: self)
    }
    
    /// The year previous to the year containing the date.
    var previousYear: Int {
        year - 1
    }
    
    /// The year following to the year containing the date.
    var nextYear: Int {
        year + 1
    }
}

extension Int {
    /// Whether the year is a leap year.
    var isLeapYear: Bool {
        self % 100 == 0 ? self % 400 == 0 : self % 4 == 0
    }
    
    /// The number of days in the year.
    var daysInYear: Int {
        isLeapYear ? 366 : 365
    }
}
