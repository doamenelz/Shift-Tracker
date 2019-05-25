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
    
    let context = CONTEXT
    
    //MARK: - Variables
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
    var weekStarting = ""
    
    //MARK: - Outlets and Actions
    //Outlets
    @IBOutlet weak var weekStartingLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    //Actions
    @IBAction func backPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shiftsLoaded = loadShiftsFromContextGeneric(context: context)
        parseShift()
        tableView.dataSource = self
        tableView.delegate = self
        weekStartingLabel.text = "This Week"
}
    
    //MARK: - TableView Methods
    //Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parsedShifts.count
    }
    
    //Datasource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "expandedShiftCell", for: indexPath) as? ShiftExpandedCell {
            cell.configureCell(shift: parsedShifts[indexPath.row])
            shiftStatusFormatting(shiftStatus: parsedShifts[indexPath.row], view: cell.statusView, oval: cell.statusOval)
            return cell
    }
        return UITableViewCell()
}
    
    //Manipulation
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCell = parsedShifts[indexPath.row]
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
            let alertController = UIAlertController(
                title: "Delete Shift?",
                message: "This cannot be undone",
                preferredStyle: UIAlertController.Style.alert
            )

            let cancelAction = UIAlertAction(
                title: "CANCEL",
                style: UIAlertAction.Style.destructive) { (action) in
            }
            
            let confirmAction = UIAlertAction(
            title: "YES", style: UIAlertAction.Style.default) { (action) in
                self.context.delete(self.statusToSave!)
                self.parsedShifts.remove(at: indexPath.row)
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
    
    //MARK: - Data Manipulation Methods
    func parseShift () {
        let previousMonday = Date().previous(.monday, considerToday: true)
        let nextSunday = Date.today().next(.sunday, considerToday: true)
        let range = previousMonday...nextSunday
        
        for item in shiftsLoaded {
            if range.contains(item.startShiftDate!) {
                parsedShifts.append(item)
            }
        }
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
