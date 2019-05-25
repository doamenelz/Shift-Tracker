//
//  ManageWorkspace.swift
//  My Shift Calculator
//
//  Created by Ed Em on 2019-05-15.
//  Copyright © 2019 Ed Em. All rights reserved.
//

import UIKit
import CoreData

class ManageWorkspace: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let context = CONTEXT
    
    //Variables
    var workplaceArray = [Workplace]()
    var workplaceToDelete: Workplace?
    var loadedShifts = [Shift]()
    
    //Outlets
    @IBOutlet weak var tableView: UITableView!
        
    @IBOutlet weak var adBtn: CustomBtnLarge!
    
    @IBAction func addNewPressed(_ sender: Any) {
        performSegue(withIdentifier: "toAddNewWorkplace", sender: nil)
    }
    
    //Actions
    @IBAction func backPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchContext()
        loadedShifts = loadShiftsFromContextGeneric(context: CONTEXT)
        setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        workplaceArray = []
        self.fetchContext()
        self.tableView.reloadData()
        print("I got here")
    }
    
    //TableViewSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return workplaceArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "workplaceCell", for: indexPath) as? ManageWorkspaceCell {
            cell.configureCell(workPlace: workplaceArray[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
    workplaceToDelete = self.workplaceArray[indexPath.row]
        
        let deleteShift = UIContextualAction(style: .normal, title: "Delete Shift") { (action, view, completionHandler) in
            let alertController = UIAlertController(
                title: "Delete Workplace?",
                message: "No worries, your created shifts will still remain",
                preferredStyle: UIAlertController.Style.alert
            )
            
            let cancelAction = UIAlertAction(
                title: "CANCEL",
                style: UIAlertAction.Style.destructive) { (action) in
                    // ...
            }
            
            let confirmAction = UIAlertAction(
            title: "YES", style: UIAlertAction.Style.default) { (action) in
                self.context.delete(self.workplaceToDelete!)
                self.workplaceArray.remove(at: indexPath.row)
           // self.saveWorkspace()
                self.saveContext(context: self.context)
                tableView.reloadData()
            }
            
            alertController.addAction(confirmAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
            
            completionHandler(true)
        }
    
        deleteShift.image = UIImage(named: "icons8-trash-can-60")
        deleteShift.backgroundColor = UIColorFromHex(rgbValue: 0xC51E2E, alpha: 0.8)
        let configuration = UISwipeActionsConfiguration(actions: [deleteShift])
        return configuration
    }
    
    func fetchContext() {
            let request : NSFetchRequest<Workplace> = Workplace.fetchRequest()
//            let sort = NSSortDescriptor(key: "startShiftDate", ascending: true)
//            request.sortDescriptors = [sort]
            do {
                workplaceArray = try context.fetch(request)
                print("----------------WorkplaceLoaded-----------------")
            } catch {
                print("Error fetching request \(error)")
            }
    }
    
    func setUpView() {
        adBtn.layer.cornerRadius = 15
    }
}
