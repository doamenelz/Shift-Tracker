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
            print("----------------AllLoadedWithContext-----------------")
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
    
}


