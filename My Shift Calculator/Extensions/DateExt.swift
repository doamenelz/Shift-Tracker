//
//  DateExt.swift
//  My Shift Calculator
//
//  Created by Ed Em on 2019-04-18.
//  Copyright © 2019 Ed Em. All rights reserved.
//

import Foundation
extension Date {
    func getWeekDaysInEnglish() -> [String] {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "en_US_POSIX")
        return calendar.weekdaySymbols
    }
    
    enum Weekday: String {
        case monday, tuesday, wednesday, thursday, friday, saturday, sunday
    }
    
    enum SearchDirection {
        case Next
        case Previous
        
        var calendarSearchDirection: Calendar.SearchDirection {
            switch self {
            case .Next:
                return .forward
            case .Previous:
                return .backward
            }
        }
    }
    
    static func today() -> Date {
        return Date()
    }
    
    func next(_ weekday: Weekday, considerToday: Bool = false) -> Date {
        return get(.Next,
                   weekday,
                   considerToday: considerToday)
    }
    
    func previous(_ weekday: Weekday, considerToday: Bool = false) -> Date {
        return get(.Previous,
                   weekday,
                   considerToday: considerToday)
    }
    
    func get(_ direction: SearchDirection,
             _ weekDay: Weekday,
             considerToday consider: Bool = false) -> Date {
        
        let dayName = weekDay.rawValue
        
        let weekdaysName = getWeekDaysInEnglish().map { $0.lowercased() }
        
        assert(weekdaysName.contains(dayName), "weekday symbol should be in form \(weekdaysName)")
        
        let searchWeekdayIndex = weekdaysName.firstIndex(of: dayName)! + 1
        
        let calendar = Calendar(identifier: .gregorian)
        
        if consider && calendar.component(.weekday, from: self) == searchWeekdayIndex {
            return self
        }
        
        var nextDateComponent = DateComponents()
        nextDateComponent.weekday = searchWeekdayIndex
        
        
        let date = calendar.nextDate(after: self,
                                     matching: nextDateComponent,
                                     matchingPolicy: .nextTime,
                                     direction: direction.calendarSearchDirection)
        
        return date!
    }
    
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour,.minute], from: date, to: self).hour ?? 0
    }
    
    func hoursForDouble(from date: Date) -> Int {
          return Calendar.current.dateComponents([.hour,.minute], from: date, to: self).minute ?? 0
    }
    
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
        }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
}

extension DateFormatter {
    func formating(dateFormatter: DateFormatter) {
        dateFormatter.dateFormat = "MMM d, h:mm a"
        
    }
}

extension DateComponentsFormatter {
    
    func dateComponentsFormatter (dateComponentsFormatter: DateComponentsFormatter) {
        dateComponentsFormatter.allowedUnits = [.day,.hour, .minute]
        dateComponentsFormatter.maximumUnitCount = 2
        dateComponentsFormatter.unitsStyle = .brief
        dateComponentsFormatter.string(from: Date(), to: Date(timeIntervalSinceNow: 4000000))
    }
  
}
