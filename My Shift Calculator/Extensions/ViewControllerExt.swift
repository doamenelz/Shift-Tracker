//
//  ViewControllerExt.swift
//  My Shift Calculator
//
//  Created by Ed Em on 2019-05-18.
//  Copyright © 2019 Ed Em. All rights reserved.
//

import UIKit
import Foundation
import CoreData

extension UIViewController {
    
    func loadShiftsFromContextGeneric (context: NSManagedObjectContext) -> [Shift]{
        let request : NSFetchRequest<Shift> = Shift.fetchRequest()
        let sort = NSSortDescriptor(key: "startShiftDate", ascending: true)
        request.sortDescriptors = [sort]
        var shift = [Shift]()
        do {
             shift = try context.fetch(request)
        } catch {
            print("Error fetching request \(error)")
        }
        return shift
    }
    
    func saveContext (context: NSManagedObjectContext) {
        do {
            try context.save()
            print("Context Saved")
        } catch {
            print("Error saving category \(error)")
        }
    }
    
    func confirmAction (title: String) {
        let alertController = UIAlertController(
            title: title,
            message: "",
            preferredStyle: UIAlertController.Style.alert
        )
        
        let confirmAction = UIAlertAction(
        title: "DONE", style: UIAlertAction.Style.default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(confirmAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}

extension UIView {
    func hide(){
        isHidden = true
    }
    
    func show(){
        isHidden = false
    }
}

