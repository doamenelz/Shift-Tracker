//
//  ViewShiftsVC.swift
//  My Shift Calculator
//
//  Created by Ed Em on 2019-04-04.
//  Copyright © 2019 Ed Em. All rights reserved.
//

import UIKit
import CoreData

class ViewShiftsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //MARK: - CoreData Context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //Variables
    private var shiftsArray = [Shift]()

    //MARK: - Outlets and Actions
    //Outlets
    @IBOutlet weak var tableView: UITableView!
    
    //Actions
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func expndCellPressed(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 75
        tableView.rowHeight = UITableView.automaticDimension
    }
   
    //MARK: - Table Methods
    //Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shiftsArray.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToShiftsSeg", sender: self)
    }
    
    //Data Manipulation
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ShiftCell", for: indexPath) as? ShiftCell {
           cell.configureCell(shift: shiftsArray[indexPath.row])
            return cell
        } else {
            return UITableViewCell()
        }
    }

    func loadItems () {
        let request : NSFetchRequest<Shift> = Shift.fetchRequest()
        do {
        shiftsArray = try context.fetch(request)
        } catch {
            print("Error fetching request \(error)")
        }
    }

    //MARK: - Others
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ShiftExpandedVC
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.shiftsLoaded = [shiftsArray[indexPath.row]]
        }
    }

}
