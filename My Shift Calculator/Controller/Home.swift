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
    
    //MARK: - Variables
    var shiftsLoaded = [Shift]()
    var weekShift = [Shift]()
    var nextShift : Shift?
    var nextShiftsArray = [Shift]()
    var dateFormatter = DateFormatter()
    var headerFormatter = DateFormatter()
    var dateCmpntsFormatter = DateComponentsFormatter()
    var weekStarting = ""
    
    //MARK: - Outlets
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
    @IBOutlet weak var clockBtn: CustomizeBtn!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var statusOval: UIImageView!
    @IBOutlet weak var shiftDurationLbl: UILabel!
    @IBOutlet weak var weekStartingLbl: UILabel!
    
    @IBOutlet weak var shiftView: UIView!
    @IBOutlet weak var topBorderView: UIView!
    
    //Static Outlets
    @IBOutlet weak var locationIcon: UIImageView!
    @IBOutlet weak var oval1: UIImageView!
    @IBOutlet weak var oval2: UIImageView!
    @IBOutlet weak var dividerView: UIView!
    
    //MARK: - Actions
    @IBAction func settings(_ sender: Any) {
        
    }
    
    @IBAction func viewAllPressed(_ sender: Any) {
        //Nav to Shifts StoryBoard
        let destinationVC = UIStoryboard(name: "Shifts", bundle: nil).instantiateViewController(withIdentifier: "ShiftExpandedVC") as! ShiftExpandedVC
       destinationVC.weekStarting = weekStarting
        self.present(destinationVC, animated: true, completion: nil)

    }
    
    @IBAction func addShiftPressed(_ sender: Any) {
        
    }
    @IBAction func clockButtonPressed(_ sender: Any) {
    }
    
    //MARK: - Default Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        dateCmpntsFormatter.dateComponentsFormatter(dateComponentsFormatter: dateCmpntsFormatter)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("reloadingShift")
        weekShift = []
        print("Conextloading = \(weekShift.count)")
        print("----------------setUpViewNext------------")
        setUpView()
             print("----------------loadshiftcontext------------")
        loadShiftsFromContext()
             print("----------------getweekshift------------")
        getWeekShifts()
             print("----------------parsenextshift------------")
        parseNextShift()
        
    }
    
    //MARK: - Data Manipulation Functions
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
    func loadShiftsFromContext() {
        let request: NSFetchRequest<Shift> = Shift.fetchRequest()
        let sort = NSSortDescriptor(key: "startShiftDate", ascending: true)
        request.sortDescriptors = [sort]
        do {
            shiftsLoaded = try context.fetch(request)
           // print("Shift data successfully fetched \(request)")
        } catch {
            print("Error fetching request \(error)")
        }
    }
    func getWeekShifts () {
        //Determine date in WeekRange
        let previousMonday = Date.today().previous(.monday)
        let nextSunday = Date.today().next(.sunday)
        let range = previousMonday...nextSunday
       
        //Parse Date to Formatted String
      let tempDate = " \(previousMonday)"
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd,yyyy"
        
        if let date = dateFormatterGet.date(from: tempDate) {
            weekStarting = "Week Starting \(dateFormatterPrint.string(from: date))"
            weekStartingLbl.text = weekStarting
        } else {
            print("There was an error decoding the string")
        }

        //Get weekly shifts
        for item in shiftsLoaded {
            if range.contains(item.startShiftDate!) {
                weekShift.append(item)
            }
        }
        print("My parsed shifts are \(weekShift.count)")
    }
    func parseNextShift () {
        
        if weekShift.isEmpty {
            print("Nothing to parse today")
        } else {
            nextShiftsArray = []
            
            //Parse shifts into >= today
            for shift in weekShift {
                if shift.startShiftDate! >= Date() {
                    nextShiftsArray.append(shift)
                }
            }
        }
        dateFormatter.dateFormat = "h:mm a"
        headerFormatter.dateFormat = "E, MMM d" // "MMM d, h:mm a"

        //Parse Next Shift to bottom card
        if nextShiftsArray.isEmpty {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
            label.font = UIFont.preferredFont(forTextStyle: .footnote)
            label.textColor = #colorLiteral(red: 0.4274509804, green: 0.4745098039, blue: 0.5764705882, alpha: 1)
            label.text = "No Upcoming Shifts!"
            self.shiftView.addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.centerXAnchor.constraint(equalTo: shiftView.centerXAnchor).isActive = true
            label.centerYAnchor.constraint(equalTo: shiftView.centerYAnchor).isActive = true
            
            //Hide IBOutlets
            clockBtn.isHidden = true
            officeLocationLbl.isHidden = true
            startTimeLbl.isHidden = true
            endTimeLbl.isHidden = true
            shiftDateLbl.isHidden = true
            statusLbl.isHidden = true
            statusOval.isHidden = true
            statusView.isHidden = true
            shiftDurationLbl.isHidden = true
            locationIcon.isHidden = true
            oval1.isHidden = true
            oval2.isHidden = true
            dividerView.isHidden = true
            shiftView.frame.size.height = 130
            print("No Shift")
        } else {
            nextShift = nextShiftsArray.first
            print("Shift Array count \(nextShiftsArray.count)")
            officeLocationLbl.text = nextShift?.workPlaceName
            statusLbl.text = nextShift?.status
            shiftDateLbl.text = headerFormatter.string(from: nextShift!.startShiftDate!)
            startTimeLbl.text = dateFormatter.string(from: nextShift!.startShiftDate!)
            endTimeLbl.text = dateFormatter.string(from: nextShift!.endShiftDate!)
            shiftStatusFormatting(shiftStatus: nextShift!, view: statusView, oval: statusOval)
            shiftDurationLbl.text = dateCmpntsFormatter.string(from: nextShift!.startShiftDate!, to: nextShift!.endShiftDate!)
        }
    }
    
    
    func calculateProjectedHours () {
        for shift in shiftsLoaded {
            
        }
    }
    
    
}


