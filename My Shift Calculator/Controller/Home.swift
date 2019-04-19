//
//  Home.swift
//  My Shift Calculator
//
//  Created by Ed Em on 2019-04-01.
//  Copyright © 2019 Ed Em. All rights reserved.
//

import UIKit
import CoreData
@IBDesignable

class Home: UIViewController {

    
    //Context
     let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //Variables
    var shiftsLoaded = [Shift]()
    var weekShift = [Shift]()
    var nextShift : Shift?
    var nextShiftsArray = [Shift]()
    var dateFormatter = DateFormatter()
    var headerFormatter = DateFormatter()
    
    //Outlets
   
    @IBOutlet weak var dashBoardView: UIImageView!
    
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var dashboardView: UIView!
    @IBOutlet weak var viewAllBtn: UIButton!
    @IBOutlet weak var addShiftBtn: CustomizeBtn!
    @IBOutlet weak var shiftDateLbl: UILabel!
    @IBOutlet weak var officeLocationLbl: UILabel!
    @IBOutlet weak var shiftPeriodLbl: UILabel!
    @IBOutlet weak var startTimeLbl: UILabel!
    @IBOutlet weak var endTimeLbl: UILabel!
    @IBOutlet weak var durationDescription: UILabel!
    @IBOutlet weak var clockBtn: CustomizeBtn!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var statusOval: UIImageView!
    @IBOutlet weak var shiftDurationLbl: UILabel!
    
    @IBOutlet weak var shiftView: UIView!
    @IBOutlet weak var topBorderView: UIView!
    

    
    //Actions
    @IBAction func settings(_ sender: Any) {
        
    }
    
    @IBAction func viewAllPressed(_ sender: Any) {
        //Nav to Shifts StoryBoard
        let VC = UIStoryboard(name: "Shifts", bundle: nil).instantiateViewController(withIdentifier: "ShiftExpandedVC") as! ShiftExpandedVC
        self.present(VC, animated: true, completion: nil)

    }
    
    @IBAction func addShiftPressed(_ sender: Any) {
        
    }
    @IBAction func clockButtonPressed(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        loadItems()
       parseShift()
       parseNextShift()
       shiftStatusFormatting(shiftStatus: nextShift!, view: statusView, oval: statusOval)
        // Do any additional setup after loading the view.
    }
    
    func setUpView () {
       
        //DashBoard Adjustments
        dashboardView.layer.cornerRadius = 13
        dashBoardView.layer.cornerRadius = 13
        self.dashboardView.layer.shadowColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        self.dashboardView.layer.shadowOpacity = 0.6
        self.dashboardView.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.dashboardView.layer.shadowRadius = 2
        self.dashBoardView.layer.masksToBounds = true
        statusView.layer.cornerRadius = 10
 
        //ShiftView Adjustments
        shiftView.layer.cornerRadius = 13
        shiftView.layer.borderWidth = 0.2
        shiftView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        topBorderView.layer.cornerRadius = 13
        topBorderView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }

    func parseNextShift () {
  
        dateFormatter.dateFormat = "h:mm a"
        headerFormatter.dateFormat = "MMM d, h:mm a" // "MMM d, h:mm a"
      
        //check if parsed shift is
        nextShift = nextShiftsArray.first
        if nextShiftsArray.isEmpty {
            print("No Shift")
        } else {
            officeLocationLbl.text = nextShift?.workPlaceName
            statusLbl.text = nextShift?.status
            shiftDateLbl.text = headerFormatter.string(from: nextShift!.startShiftDate!)
            startTimeLbl.text = dateFormatter.string(from: nextShift!.startShiftDate!)
            endTimeLbl.text = dateFormatter.string(from: nextShift!.endShiftDate!)
        }
    }
    
    func loadItems() {
        let request: NSFetchRequest<Shift> = Shift.fetchRequest()
        
        do {
            shiftsLoaded = try context.fetch(request)
           // print("Shift data successfully fetched \(request)")
        } catch {
            print("Error fetching request \(error)")
        }
    }

    func parseShift () {
        let previousMonday = Date.today().previous(.monday)
        let nextSunday = Date.today().next(.sunday)
        let range = previousMonday...nextSunday
       
        //Get weekly shifts
        for item in shiftsLoaded {
            if range.contains(item.startShiftDate!) {
                weekShift.append(item)
               print("My parsed shifts are \(weekShift.count)")
                
                for shift in weekShift {
                    if shift.startShiftDate! >= Date() {
                        
                        //print(" startshift date is \(shift.startShiftDate)")
                        nextShiftsArray.append(shift)
                        print(nextShiftsArray.count)
                    }
                }

            }
        }
    }


}


