//
//  CreateWorkplaceVC.swift
//  My Shift Calculator
//
//  Created by Ed Em on 2019-04-02.
//  Copyright © 2019 Ed Em. All rights reserved.
//

import UIKit
import CoreData


class CreateWorkplaceVC: UIViewController {

    //Create Context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //Variables
    var modalDisplay = ""
   
    //Outlets
    @IBOutlet weak var workplaceTxtFld: CustomTxtField!
    @IBOutlet weak var ratesTxtFld: CustomTxtField!
    @IBOutlet weak var createBtn: CustomBtnSmallerModel!
    @IBOutlet weak var failedMessage: UILabel!
    
    //Actions
    @IBAction func createWrkPlacePressed(_ sender: Any) {
        
        if (workplaceTxtFld.text != "") && (ratesTxtFld.text != "") {
            let newWorkplace = Workplace(context: self.context)
            newWorkplace.workPlaceName = workplaceTxtFld.text!
            newWorkplace.rates = Double(ratesTxtFld.text!)!
            saveWorkplace()
           
            print("Create Btn Pressed")
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SuccessModal") as! SuccessModal
            vc.modalMessage = self.modalDisplay
            self.present(vc, animated: false, completion: nil)
            print("Values arent empty")
        } else {
           failedMessage.isHidden = false
        }

        
    }
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        failedMessage.isHidden = true
       
    }

    func saveWorkplace() {
        do {
            try context.save()
            print("Context Saved! \(context)")
            modalDisplay = "Workplace was added successfully!"
        } catch {
            print("Error saving context \(error)")
        }
        
    }

    //Bind Keyboard
    
    //Change back btn to unwind VC

}
