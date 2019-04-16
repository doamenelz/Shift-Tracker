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

    

  
     let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var shiftsArray = [Shift]()

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
        print(shiftsArray)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 75
        tableView.rowHeight = UITableView.automaticDimension
        // Do any additional setup after loading the view.
    }
   
    //MARK: - Table Datasource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shiftsArray.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToShiftsSeg", sender: self)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ShiftCell", for: indexPath) as? ShiftCell {
           cell.configureCell(shift: shiftsArray[indexPath.row])
            return cell
            
        } else {
            return UITableViewCell()
        }

    }

    func loadItems () {
        //Create a new Constant
        let request : NSFetchRequest<Shift> = Shift.fetchRequest()
        do {
        shiftsArray = try context.fetch(request)
            print("Shift data successfully fetched \(request)")
        } catch {
            print("Error fetching request \(error)")
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ShiftExpandedVC
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.shiftsLoaded = [shiftsArray[indexPath.row]]
        }
    }

}
