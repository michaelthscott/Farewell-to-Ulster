//
//  DateIntervalTests.swift
//  FarewellToUlsterTests
//
//  Created by Michael Scott on 13/05/2026.
//

import Foundation
import Testing
@testable import FarewellToUlster

// TODO: Make it clear what is meant by period and days.

struct DateIntervalTests {
    static let secondsInADay: TimeInterval = 86400.0
    static let formatter: ISO8601DateFormatter = {
        ISO8601DateFormatter()
    }()
    
    func date(_ string: String) -> Date {
        guard let date = Self.formatter.date(from: string) else { fatalError() }
        return date
    }
    
    func string(_ date: Date) -> String {
        Self.formatter.string(from: date)
    }
    
    @Test func testDateIntervalJSON() async throws {
        struct DateIntervalJSON: Codable {
            let period: DateInterval
            
            init(period: DateInterval) {
                self.period = period
            }
            
            enum CodingKeys: String, CodingKey {
                case period = "period"
            }
            
            func encode(to encoder: any Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)
                try container.encode(period, forKey: .period)
            }
            
            init(from decoder: any Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                period = try container.decode(DateInterval.self, forKey: .period)
            }
        }
        let startString = "1900-01-01T00:00:00Z"
        let endString = "1954-04-24T00:00:00Z"
        let start = date(startString)
        let end = date(endString)
        let period = DateInterval(start: start, end: end)
        let dateIntervalJSON = DateIntervalJSON(period: period)
        let encoder = JSONEncoder()
        let jsonData = try encoder.encode(dateIntervalJSON)
        let decoder = JSONDecoder()
        let decoded = try decoder.decode(DateIntervalJSON.self, from: jsonData)
        #expect(string(decoded.period.start) == startString)
        #expect(string(decoded.period.end) == endString)
    }
    
    @Test func testUpdateDayIncrement() {
        let start = date("1954-04-24T00:00:00Z")
        var period = DateInterval(start: start, duration: 0)
        
        #expect(period.duration == 0)
        #expect(period.days == 1)
        #expect(period.start == start)
        #expect(period.end == start)
        #expect(period.periodDescription == "24 Apr 1954")
        
        period.duration = 1.0
        #expect(period.duration == 1.0)
        #expect(period.days == 1)
        #expect(period.start == start)
        #expect(period.end == start + 1.0)
        #expect(period.periodDescription == "24 Apr 1954")
        
        period.duration = Self.secondsInADay
        #expect(period.duration == Self.secondsInADay)
        #expect(period.days == 1)
        #expect(period.start == start)
        #expect(period.end == start + Self.secondsInADay)
        #expect(period.periodDescription == "24 Apr 1954")
        
        period.increment(by: .day)
        #expect(period.start == start)
        #expect(period.end == start + (Self.secondsInADay * 2))
        #expect(period.days == 2)
        #expect(period.periodDescription == "24 Apr 1954 - 25 Apr 1954")
    }
    
    @Test func testUpdateWeekIncrement() {
        let start = date("1954-04-24T00:00:00Z")
        var period = DateInterval(start: start, duration: 0)

        period.increment(by: .week)
        #expect(period.start == start)
        #expect(period.end == start + (Self.secondsInADay * 7))
        #expect(period.days == 7)
        #expect(period.periodDescription == "24 Apr 1954 - 30 Apr 1954")
    }
    
    @Test func testUpdateYearIncrement() {
        let start = date("1954-04-24T00:00:00Z")
        var period = DateInterval(start: start, duration: 0)
        
        period.increment(by: .year)
        #expect(period.start == start)
        #expect(period.end == start + (Self.secondsInADay * Double(1954.daysInYear)))
        #expect(period.days == 1954.daysInYear)
        #expect(period.periodDescription == "24 Apr 1954 - 23 Apr 1955")
    }

    @Test func testYearStartEnd() {
        let start = date("1954-04-24T00:00:00Z")
        let end = date("1955-04-24T00:00:00Z")
        let period = DateInterval(start: start, end: end)
        
        #expect(period.start == start)
        #expect(period.end == end)
        // Neither 1954 or 1955 are leap years.
        #expect(period.days == 365)
        // TODO: Note that end is not included in the period
        #expect(period.end.description == "1955-04-24 00:00:00 +0000")
        #expect(period.periodDescription == "24 Apr 1954 - 23 Apr 1955")
    }

    @Test func testLeapYearStartEnd() {
        let start = date("1951-04-24T00:00:00Z")
        let end = date("1952-04-24T00:00:00Z")
        let period = DateInterval(start: start, end: end)
        
        #expect(period.start == start)
        #expect(period.end == end)
        // 1952 is a leap year.
        #expect(period.days == 366)
        #expect(period.periodDescription == "24 Apr 1951 - 23 Apr 1952")
    }

    @Test func testCalendar() {
        let start = date("1954-04-24T00:00:00Z")
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(abbreviation: "UTC")!
        
        let period = calendar.dateInterval(of: .day, for: start)!
        #expect(period.start == start)
        #expect(period.end == start + Self.secondsInADay)
        #expect(period.periodDescription == "24 Apr 1954")
        
        var date: Date = .now
        var duration: TimeInterval = 0.0
        #expect(calendar.dateInterval(of: .day, start: &date, interval: &duration, for: start))
        #expect(date == start)
        #expect(duration == Self.secondsInADay)
    }
}
