//
//  ShiftExpandedVC.swift
//  My Shift Calculator
//
//  Created by Ed Em on 2019-04-15.
//  Copyright © 2019 Ed Em. All rights reserved.
//

import UIKit
import CoreData

enum ShiftStatus {
    case completed
    case cancelled
    case scheduled
}

class ShiftExpandedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //Outlets
    var shiftsLoaded = [Shift]()
    var parsedShifts = [Shift]()
    var selectedCell: Shift?
    var changingCell = ShiftExpandedCell()
    
    @IBOutlet weak var weekStartingLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    

//Actions
    @IBAction func backPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
        parseShift()

        tableView.dataSource = self
        tableView.delegate = self
        //print(stackStatus)
}
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // return shiftsLoaded.count
        return parsedShifts.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       selectedCell = parsedShifts[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "expandedShiftCell", for: indexPath) as? ShiftExpandedCell {
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
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

         let statusToSave = self.parsedShifts[indexPath.row]
        let deleteShift = UIContextualAction(style: .normal, title: "Delete Shift") { (action, view, completionHandler) in
//            statusToSave.status = "Completed"
//            self.saveShift()
            completionHandler(true)
        }
        
        let cancelShift =  UIContextualAction(style: .normal, title: "CancelShift", handler: { (action,view,completionHandler ) in
            statusToSave.status = "Cancelled"
            self.saveShift()
            completionHandler(true)
        })
        
        //deleteShift.image = UIImage(named: "icons8-delete-bin-96")
        cancelShift.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteShift,cancelShift])
        return configuration
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let statusToSave = self.parsedShifts[indexPath.row]
        let markCompleted = UIContextualAction(style: .normal, title: "Mark as Complete") { (action, view, completionHandler) in
            statusToSave.status = "Completed"
            self.saveShift()
            completionHandler(true)
        }
        //deleteShift.image = UIImage(named: "icons8-delete-bin-96")
        markCompleted.backgroundColor = #colorLiteral(red: 0.363037467, green: 0.7854679227, blue: 0.330747813, alpha: 1)
        
        let configuration = UISwipeActionsConfiguration(actions: [markCompleted])
        return configuration
        
    }
    func saveShift () {
        do {
            try context.save()
            print("Context Saved")
        } catch {
            print("Error saving category \(error)")
        }
        tableView.reloadData()
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
