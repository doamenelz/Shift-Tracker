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
    var selectedCell: Shift?
    var changingCell = ShiftExpandedCell()
    var alertConfirm: String = ""
    var alertCancel: String = ""
    var alertTitle: String = ""
    var alertMessage: String = ""
    
    var askToDeleteShift: Bool = false
    var statusToSave: Shift?
    
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

         statusToSave = self.parsedShifts[indexPath.row]
       
        let deleteShift = UIContextualAction(style: .normal, title: "Delete Shift") { (action, view, completionHandler) in
          //  self.askToDeleteShift = true
            let alertController = UIAlertController(
                title: "Delete Shift?",
                message: "This cannot be undone",
                preferredStyle: UIAlertController.Style.alert
            )

            let cancelAction = UIAlertAction(
                title: "CANCEL",
                style: UIAlertAction.Style.destructive) { (action) in
                    // ...
            }

            let confirmAction = UIAlertAction(
            title: "YES", style: UIAlertAction.Style.default) { (action) in
                self.context.delete(self.statusToSave!)
                self.parsedShifts.remove(at: indexPath.row)
               self.saveShift()
                print("Yes pressed")
            }

            alertController.addAction(confirmAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
            
            print("delete pressed")
            completionHandler(true)
        }
        
        let cancelShift =  UIContextualAction(style: .normal, title: "\n Cancel Shift", handler: { (action,view,completionHandler ) in
            self.alertTitle = "Shift has been cancelled!"
            self.alertCancel = "Cancel Shift?"
            self.statusToSave!.status = "Cancelled"
            self.confirmAction()
            //self.saveShift()
            completionHandler(true)
        })

        deleteShift.image = UIImage(named: "icons8-trash-can-60")
        cancelShift.image = UIImage(named: "icons8-cancel-60")
        deleteShift.backgroundColor = UIColorFromHex(rgbValue: 0xC51E2E, alpha: 0.8)
        cancelShift.backgroundColor = UIColorFromHex(rgbValue: 0xCD5C5C, alpha: 0.8)
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteShift,cancelShift])
        return configuration
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let statusToSave = self.parsedShifts[indexPath.row]
        alertTitle = "Shift Completed!"
        askToDeleteShift = false
        let markCompleted = UIContextualAction(style: .normal, title: "Mark as Complete") { (action, view, completionHandler) in
            statusToSave.status = "Completed"
            self.confirmAction()
            completionHandler(true)
        }
        markCompleted.backgroundColor = #colorLiteral(red: 0.363037467, green: 0.7854679227, blue: 0.330747813, alpha: 1)
        markCompleted.image = UIImage(named: "icons8-checked-60")
        
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
    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }

    func confirmAction () {
        let alertController = UIAlertController(
            title: alertTitle,
            message: alertMessage,
            preferredStyle: UIAlertController.Style.alert
        )
        
        _ = UIAlertAction(
            title: "CANCEL",
            style: UIAlertAction.Style.destructive) { (action) in
                // ...
        }
        
        let confirmAction = UIAlertAction(
        title: "OK", style: UIAlertAction.Style.default) { (action) in
            self.saveShift()
        }
           // self.saveShift()
        

        alertController.addAction(confirmAction)
        //alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
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
