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

    let context = CONTEXT
    
    //MARK: - Variables
    var modalDisplay = ""
   
    //MARK: - Outlets & Actions
    //Outlets
    @IBOutlet weak var workplaceTxtFld: CustomTxtField!
    @IBOutlet weak var ratesTxtFld: CustomTxtField!
    @IBOutlet weak var createBtn: CustomBtnSmallerModel!
    @IBOutlet weak var failedMessage: UILabel!
    @IBOutlet weak var backGroundView: UIView!
    
    //Actions
    @IBAction func createWrkPlacePressed(_ sender: Any) {
        
        if (workplaceTxtFld.text != "") && (ratesTxtFld.text != "") {
            let newWorkplace = Workplace(context: self.context)
            newWorkplace.workPlaceName = workplaceTxtFld.text!
            newWorkplace.rates = Double(ratesTxtFld.text!)!
            newWorkplace.dateCreated = Date()
            saveWorkplace()
           
            print("Create Btn Pressed")
            
            let title = "Workplace Created!"
                        
            confirmAction(title: title)
        } else {
           failedMessage.isHidden = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        failedMessage.isHidden = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CreateWorkplaceVC.handleTap(_:)))
        backGroundView.addGestureRecognizer(tapGesture)
        
       bindToKeyboard()
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

    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        resignFirstResponder()
        dismiss(animated: false, completion: nil)
    }
}
