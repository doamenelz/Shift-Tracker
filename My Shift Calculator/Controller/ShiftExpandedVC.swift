//
//  ShiftExpandedVC.swift
//  My Shift Calculator
//
//  Created by Ed Em on 2019-04-15.
//  Copyright © 2019 Ed Em. All rights reserved.
//

import UIKit
import CoreData

class ShiftExpandedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//Outlets
    var shiftsLoaded = [Shift]()
    var parsedShifts = [Shift]()
    @IBOutlet weak var weekStartingLabel: UILabel!
    
//Actions
    @IBAction func backPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
        parseShift()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // return shiftsLoaded.count
        return parsedShifts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "expandedShiftCell", for: indexPath) as? ShiftExpandedCell {
            //cell.configureCell(shift: shiftsLoaded[indexPath.row])
            cell.configureCell(shift: parsedShifts[indexPath.row])
            return cell

    }
    return UITableViewCell()

}
    func loadItems () {
        //Create a new Constant
        let request : NSFetchRequest<Shift> = Shift.fetchRequest()
        do {
            shiftsLoaded = try context.fetch(request)
            print("Shift data successfully fetched \(request)")
        } catch {
            print("Error fetching request \(error)")
        }
    }

    
    func parseShift () {
       let previousMonday = Date.today().previous(.monday)
        let nextSunday = Date.today().next(.sunday)
       
        let range = previousMonday...nextSunday
        
        for item in shiftsLoaded {
            if range.contains(item.startShiftDate!) {
                parsedShifts.append(item)
            }
        }
    }
    
    
}

extension Date {
    
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
        
        let searchWeekdayIndex = weekdaysName.index(of: dayName)! + 1
        
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
    
}

// MARK: Helper methods
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
}
