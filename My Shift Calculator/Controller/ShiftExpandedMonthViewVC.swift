//
//  ShiftExpandedMonthViewVC.swift
//  My Shift Calculator
//
//  Created by Ed Em on 2019-05-18.
//  Copyright © 2019 Ed Em. All rights reserved.
//

import UIKit
import iOSDropDown
import CoreData
import PullToDismissTransition


class ShiftExpandedMonthViewVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let context = CONTEXT

    //MARK: - Variables
    var shiftsLoaded = [Shift]()
    var monthShift = [Shift]()
    var lastDayOfMonth = Date()
    var firstDayOfMonth = Date()
    let calendar = Calendar.current
    var monthInText = ""
    var monthInInt = 0
    var dateComponents = DateComponents()
    var actualEarningsArray = [Double]()
    var actualEarnings: Double?
    var actualWorkedHoursArray = [Double]()
    var actualWorkedHours: Double?
    var workPlaces = [String]()
    
    var alertConfirm: String = ""
    var alertCancel: String = ""
    var alertTitle: String = ""
    var alertMessage: String = ""
    
    var askToDeleteShift: Bool = false
    var statusToSave: Shift?

    //MARK: - Outlets and Actions
    
    //Outlets
    @IBOutlet weak var dropDown: DropDown!
    @IBOutlet weak var summaryView: UIView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var earnedAmtMnth: UILabel!
    @IBOutlet weak var workedAmnt: UILabel!
    @IBOutlet weak var workPlaceCount: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var switchBtn: CustomBtnLarge!
    @IBOutlet weak var shiftsSectionLbl: UILabel!
    
    //Actions
    @IBAction func backPressed(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shiftsLoaded = loadShiftsFromContextGeneric(context: context)
        setupView()
        tableView.dataSource = self
        tableView.delegate = self
        
        dropDown.listWillAppear {
            self.summaryView.isHidden = true
            self.tableView.isHidden = true
            self.shiftsSectionLbl.isHidden = true
        }
        dropDown.listDidDisappear {
            self.summaryView.isHidden = false
            self.tableView.isHidden = false
            self.shiftsSectionLbl.isHidden = false
        }
        dropDown.didSelect { (selectedText, index, id) in
           
            self.shiftsLoaded = self.loadShiftsFromContextGeneric(context: self.context)
            self.parseArrays()
            self.monthShift = []
            self.workPlaces = []
            self.monthInText = selectedText
            self.monthInInt = index
            self.getMonthsString(monthInText: selectedText)
            self.getMonthShifts(selectedDate: self.firstDayOfMonth)
            self.parseLabels()

            self.workPlaceCount.text = "\(Array(Set(self.workPlaces)).count)"
            self.tableView.reloadData()
        }
        
        getMonthShifts(selectedDate: Date())
        parseLabels()

        workPlaceCount.text = "\(Array(Set(workPlaces)).count)"
        parseArrays()
        workPlaces = []

    }
   
    //MARK: - TableView Methods
    
    //Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return monthShift.count
    }

    //Datasource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ShiftCell", for: indexPath) as? MonthlyViewCell {
            cell.configureCell(shift: monthShift[indexPath.row])
            shiftStatusFormatting(shiftStatus: monthShift[indexPath.row], view: cell.statusView, oval: cell.statusOval)
            return cell
        }
        return UITableViewCell()
    }
    
    //Manipulation
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        statusToSave = self.monthShift[indexPath.row]
        
        let deleteShift = UIContextualAction(style: .normal, title: "Delete Shift") { (action, view, completionHandler) in
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
                self.monthShift.remove(at: indexPath.row)
                self.saveContext(context: self.context)
                tableView.reloadData()
            }
            
            alertController.addAction(confirmAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
            
            completionHandler(true)
        }
        
        let cancelShift =  UIContextualAction(style: .normal, title: "Cancel Shift", handler: { (action,view,completionHandler ) in
            self.alertTitle = "Shift has been cancelled!"
            self.alertCancel = "Cancel Shift?"
            self.statusToSave!.status = "Cancelled"
            self.confirmAction()
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
        let statusToSave = self.monthShift[indexPath.row]
        
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
    
    //MARK: - Data Manipulation
    func setupView() {
        summaryView.layer.cornerRadius = 10
        summaryView.layer.shadowColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        summaryView.layer.shadowOpacity = 9
        summaryView.layer.shadowOffset = .init(width: 0, height: 2)
        summaryView.layer.shadowRadius = 2
        
         dropDown.optionArray = calendar.monthSymbols
        dropDown.selectedRowColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
       
    }
    
    func getMonthShifts (selectedDate: Date) {
        let startDate = selectedDate.startOfMonth()
        let endDate = selectedDate.endOfMonth()
        let monthRange = startDate...endDate
       
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM, yyyy"
        monthLabel.text = dateFormatter.string(from: selectedDate)
        
        for item in shiftsLoaded {
             if monthRange.contains(item.startShiftDate!) {
                monthShift.append(item)
                    
                    let tempRate = item.rates
                    let minuteDifferential = item.endShiftDate?.timeIntervalSince(item.startShiftDate!)
                    let secondsToMins = (round(100 * (minuteDifferential! / 3600)) / 100)
                    let earnedAmountPerDay = tempRate * secondsToMins
                    let tempStatus = ShiftStatus.completed.status()
                    if item.status == tempStatus {
                        actualEarningsArray.append(earnedAmountPerDay)
                        actualWorkedHoursArray.append(Double(secondsToMins))
                        workPlaces.append(item.workPlaceName!)
                    }
            }
        }
    }
    
    func parseArrays () {
        actualEarningsArray = []
        actualWorkedHoursArray = []

    }
    
    func parseLabels () {
        actualWorkedHours = actualWorkedHoursArray.reduce(0, +)
        actualEarnings = actualEarningsArray.reduce(0, +)
        earnedAmtMnth.text = "\(actualEarnings!)"
        workedAmnt.text = "\(actualWorkedHours!) Hrs"
    }
    
    func getMonthsString (monthInText: String) {
        let month: String = monthInText
        var selectedMonth: Int?
        
        dateComponents.year = calendar.component(.year, from: Date())
        dateComponents.day = 10
        switch month {
        case "January":
            selectedMonth = 1
            dateComponents.month = selectedMonth
            firstDayOfMonth = calendar.date(from: dateComponents)!
        case "February":
            selectedMonth = 2
            dateComponents.month = selectedMonth
            firstDayOfMonth = calendar.date(from: dateComponents)!
        case "March":
            selectedMonth = 3
            dateComponents.month = selectedMonth
            firstDayOfMonth = calendar.date(from: dateComponents)!
        case "April":
            selectedMonth = 4
            dateComponents.month = selectedMonth
            firstDayOfMonth = calendar.date(from: dateComponents)!
        case "May":
            selectedMonth = 5
            dateComponents.month = selectedMonth
            firstDayOfMonth = calendar.date(from: dateComponents)!
        case "June":
            selectedMonth = 6
            dateComponents.month = selectedMonth
            firstDayOfMonth = calendar.date(from: dateComponents)!
        case "July":
            selectedMonth = 7
            dateComponents.month = selectedMonth
            firstDayOfMonth = calendar.date(from: dateComponents)!
        case "August":
            selectedMonth = 8
            firstDayOfMonth = calendar.date(from: dateComponents)!
            dateComponents.month = selectedMonth
        case "September":
            selectedMonth = 9
            dateComponents.month = selectedMonth
            firstDayOfMonth = calendar.date(from: dateComponents)!
        case "October":
            selectedMonth = 10
            dateComponents.month = selectedMonth
            firstDayOfMonth = calendar.date(from: dateComponents)!
        case "November":
            selectedMonth = 11
            dateComponents.month = selectedMonth
            firstDayOfMonth = calendar.date(from: dateComponents)!
        case "December":
            selectedMonth = 12
            dateComponents.month = selectedMonth
            firstDayOfMonth = calendar.date(from: dateComponents)!
        default:
            break
        }
        
        tableView.reloadData()
        
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
            self.saveContext(context: self.context)
            self.tableView.reloadData()
            
        }
        alertController.addAction(confirmAction)
        present(alertController, animated: true, completion: nil)
    }

}
