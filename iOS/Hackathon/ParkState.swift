//
//  ParkState.swift
//  Hackathon
//
//  Created by Ian McDowell on 9/16/17.
//  Copyright © 2017 Hackathon. All rights reserved.
//

import Foundation

enum ParkStateError: Error {
    case notEnoughData
}

enum DayOfWeek: String, CustomStringConvertible, Comparable {
    case mon = "mon", tue = "tue", wed = "wed", thu = "thu", fri = "fri", sat = "sat", sun = "sun"
    
    private var order: Int {
        switch self {
        case .mon:
            return 0
        case .tue:
            return 1
        case .wed:
            return 2
        case .thu:
            return 3
        case .fri:
            return 4
        case .sat:
            return 5
        case .sun:
            return 6
        }
    }
    
    var description: String {
        switch self {
        case .mon:
            return "Monday"
        case .tue:
            return "Tuesday"
        case .wed:
            return "Wednesday"
        case .thu:
            return "Thursday"
        case .fri:
            return "Friday"
        case .sat:
            return "Saturday"
        case .sun:
            return "Sunday"
        }
    }
    
    static func <(lhs: DayOfWeek, rhs: DayOfWeek) -> Bool {
        return lhs.order < rhs.order
    }
    
    static func ==(lhs: DayOfWeek, rhs: DayOfWeek) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}
struct ParkStateTime: CustomStringConvertible, Comparable {
    let hour: Int
    let isAm: Bool
    
    static var now: ParkStateTime {
        let now = Date()
        let calendar = Calendar.current
        var hour = calendar.component(.hour, from: now)
        var isAm = true
        if hour > 12 {
            hour -= 12
            isAm = false
        }
        return ParkStateTime(hour: hour, isAm: isAm)
    }
    
    var description: String {
        return "\(hour) \(isAm ? "AM" : "PM")"
    }
    
    static func <(lhs: ParkStateTime, rhs: ParkStateTime) -> Bool {
        if lhs.isAm && !rhs.isAm {
            return true
        }
        if rhs.isAm && !lhs.isAm {
            return false
        }
        return lhs.hour < rhs.hour
    }
    
    static func ==(lhs: ParkStateTime, rhs: ParkStateTime) -> Bool {
        return lhs.hour == rhs.hour && lhs.isAm == rhs.isAm
    }
}
struct ParkStateTimeRange: CustomStringConvertible {
    let from: ParkStateTime
    let to: ParkStateTime
    
    func containsTime(time: ParkStateTime) -> Bool {
        return time >= from && time <= to
    }
    
    var description: String {
        return "between \(from.description) and \(to.description)"
    }
}
struct ParkStateDayRange: CustomStringConvertible {
    let from: DayOfWeek
    let to: DayOfWeek
    
    func containsDay(day: DayOfWeek) -> Bool {
        return day >= from && day <= to
    }
    
    var description: String {
        return "between \(from.description) and \(to.description)"
    }
}
struct ParkStateMetadata {
    let times: ParkStateTimeRange
    let days: ParkStateDayRange
}

enum ParkState {
    
    case goodToPark(timeRemaining: TimeInterval, metadata: ParkStateMetadata)
    case cantPark(reason: String, metadata: ParkStateMetadata)
    
    init(tesseractOCR: ImageOCRResult) throws {
        // MARK: BEGIN Hackiest hackathon project code ever
        
        // First, let's lowercase all the strings
        var tWords = tesseractOCR.words.map({ $0.localizedLowercase })
        
        // Look for duration first, (2 hour parking)
        let duration = ParkState.parkDuration(tWords)
        print("Duration: \(duration)")
        
        guard let tPIndex = tWords.index(of: "parking") else {
            print("Unable to find \"parking\"")
            throw ParkStateError.notEnoughData
        }
        tWords = Array(tWords[tPIndex.advanced(by: 1)..<tWords.count])
        
        guard let times = ParkState.findTimes(tWords) else {
            print("Unable to find times")
            throw ParkStateError.notEnoughData
        }
        
        guard let days = ParkState.findDays(tWords) else {
            print("Unable to find days")
            throw ParkStateError.notEnoughData
        }
        let metadata = ParkStateMetadata(times: times, days: days)
        
        // Check if we are inside the time range

        let now = ParkStateTime.now
        if !times.containsTime(time: now) {
            self = .cantPark(reason: "You can only park here \(times.description).", metadata: metadata)
            return
        }
        
        // Check if we are inside the time range
        
        
        
        self = .goodToPark(timeRemaining: duration, metadata: metadata)
        
        
        // MARK: END Hackiest hackathon project code ever
    }
    
    private static func parkDuration(_ tWords: [String]) -> TimeInterval {
        // Tesseract usually has the first word being the number of hours.
        
        guard let num = tWords.first(where: { TimeInterval($0) != nil }), let value = TimeInterval(num) else {
            return 0
        }
        return value
    }
    
    private static func findTimes(_ tWords: [String]) -> ParkStateTimeRange? {
        
        let tNums = tWords.map({ $0.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "") }).filter({ !$0.isEmpty }).flatMap({ Int($0) })
        let tAmPms = tWords.flatMap({ word -> Bool? in
            if word.contains("am") {
                return true
            } else if word.contains("pm") {
                return false
            }
            return nil
        })
//        let aNums = aWords.flatMap({ Int($0) })
        
        guard let tFirstNum = tNums.first, let tLastNum = tNums.last, tFirstNum != tLastNum, tFirstNum > 0 && tFirstNum <= 12, tLastNum > 0 && tLastNum <= 12 else {
            return nil
        }
        guard let tFirstAmPm = tAmPms.first, let tLastAmPm = tAmPms.last else {
            return nil
        }
        
        return ParkStateTimeRange(from: ParkStateTime(hour: tFirstNum, isAm: tFirstAmPm), to: ParkStateTime(hour: tLastNum, isAm: tLastAmPm))
    }
    
    private static func findDays(_ tWords: [String]) -> ParkStateDayRange? {
        let days = tWords.flatMap({ DayOfWeek.init(rawValue: $0) })
        
        guard let first = days.first, let last = days.last else {
            return nil
        }
        return ParkStateDayRange(from: first, to: last)
    }
}
