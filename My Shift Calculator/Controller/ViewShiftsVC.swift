//
//  ViewShiftsVC.swift
//  My Shift Calculator
//
//  Created by Ed Em on 2019-04-04.
//  Copyright © 2019 Ed Em. All rights reserved.
//

import UIKit

class ViewShiftsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    

    let shiftArray = ["Tuesday, 17", "Wednessday 28"]
    


    //Outlets
    
    //Actions
    @IBAction func backBtnPressed(_ sender: Any) {
        
        
    }
    @IBAction func expndCellPressed(_ sender: Any) {
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
   
    //MARK: - Table Protocols
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shiftArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShiftCell", for: indexPath)
        
        return cell
       // cell.
    }


}
