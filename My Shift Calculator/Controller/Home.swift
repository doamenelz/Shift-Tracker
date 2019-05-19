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
    var weekShiftsArray = [Shift]()
    var nextShiftsArray = [Shift]()
    var dateFormatter = DateFormatter()
    var headerFormatter = DateFormatter()
    var dateCmpntsFormatter = DateComponentsFormatter()
    var weekStarting = ""
    
    //EarningVariables
    var projectedEarningsArray = [Double]()
    var projectEarnings: Double?
    var actualEarningsArray = [Double]()
    var actualEarnings: Double?
    
    //Working Hours Variables
    var projectedHoursArray = [Double]()
    var projectedHours: Double?
    var actualWorkedHoursArray = [Double]()
    var actualWorkedHours: Double?
    
    
    //MARK: - Outlets
    //Outlets
    @IBOutlet weak var dashBoardImg: UIImageView!
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
    
    
    //Dashboard Outlets
    @IBOutlet weak var projectedHoursLbl: UILabel!
    @IBOutlet weak var actualWorkedHoursLbl: UILabel!
    @IBOutlet weak var projectedEarningsLbl: UILabel!
    @IBOutlet weak var actualEarningsLbl: UILabel!
    

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
        //destinationVC.parsedShifts = weekShift
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
        projectedEarningsArray = []
        actualEarningsArray = []
        projectedHoursArray = []
        actualWorkedHoursArray = []
        nextShiftsArray = []
        print("Conextloading = \(weekShift.count)")
        print("----------------setUpViewNext------------")
        setUpView()
             print("----------------loadshiftcontext------------")
       // loadShiftsFromContext()
        shiftsLoaded = loadShiftsFromContextGeneric(context: CONTEXT)
             print("----------------getweekshift------------")
        getWeekShifts()
             print("----------------parsenextshift------------")
        parseNextShift()
        print(" Today's date is \(Date.today())")
        
        
        //Earnings
        projectEarnings = projectedEarningsArray.reduce(0, +)
        actualEarnings = actualEarningsArray.reduce(0, +)
        actualEarningsLbl.text = "Earned: $ \(actualEarnings!)"
        projectedEarningsLbl.text = "$ \(projectEarnings!)"
       
        //Work Hours
        projectedHours = projectedHoursArray.reduce(0, +)
         projectedHoursLbl.text = "\(projectedHours!) Hrs"
        actualWorkedHours = actualWorkedHoursArray.reduce(0, +)
        actualWorkedHoursLbl.text = "Worked: \(actualWorkedHours!) Hrs"
        
        print("Projected Hours for this week is \(projectedHours!)")
        print("Project Earnings for this week is \(projectEarnings!)")
        print("Earned Income for the week is \(String(describing: actualEarnings))")
        
    }
    
    //MARK: - Data Manipulation Functions
    func setUpView () {
       
        //DashBoard Adjustments
        dashboardView.layer.cornerRadius = 13
        dashBoardImg.layer.cornerRadius = 13
        self.dashboardView.layer.shadowColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        self.dashboardView.layer.shadowOpacity = 0.6
        self.dashboardView.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.dashboardView.layer.shadowRadius = 2
        self.dashBoardImg.layer.masksToBounds = true
        statusView.layer.cornerRadius = 10
 
        //ShiftView Adjustments
        shiftView.layer.cornerRadius = 13
        shiftView.layer.borderWidth = 0.2
        shiftView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        topBorderView.layer.cornerRadius = 13
        topBorderView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        
        
    }
    

    func getWeekShifts () {

        //Determine date in WeekRange
        let previousMonday = Date().previous(.monday, considerToday: true)
        let nextSunday = Date.today().next(.sunday, considerToday: true)
        let range = previousMonday...nextSunday
        print("Previous Monday is \(previousMonday), whilst next Sunday is \(nextSunday)")
       
        //Parse Date to Formatted String
      let tempDate = " \(previousMonday)"
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd,yyyy"
        
        
        if let date = dateFormatterGet.date(from: tempDate) {
            weekStarting = "Wk Start: \(dateFormatterPrint.string(from: date))"
            weekStartingLbl.text = weekStarting
        } else {
            print("There was an error decoding the string")
        }
        
        //Get weekly shifts
        for item in shiftsLoaded {
            //Week Shift
            if range.contains(item.startShiftDate!) {
                
                let tempRate = item.rates
              
                //Get TimeInterval
                let minuteDifferential = item.endShiftDate?.timeIntervalSince(item.startShiftDate!)
                //print(minuteDifferential!)
                
                //Round Timeinterval (seconds) to Mins
                let secondsToMins = (round(100 * (minuteDifferential! / 3600)) / 100)
               //print(secondsToMins)

                //multiplication value
                let earnedAmountPerDay = tempRate * secondsToMins
                //print(tempRate)
                
                //Parse Status
                let tempStatus = ShiftStatus.completed.status()
                
                if item.status == tempStatus {
                 actualEarningsArray.append(earnedAmountPerDay)
                    actualWorkedHoursArray.append(Double(secondsToMins))
                }
                
                //appendToArray
              projectedHoursArray.append(secondsToMins)
                projectedEarningsArray.append(earnedAmountPerDay)
                weekShift.append(item)
                print("My parsed shifts are \(weekShift.count)")
            }
         
            //Next Shift
            if item.startShiftDate! > Date.today(){//.next(.sunday, considerToday: false) {
                print("I fount something")
                nextShiftsArray.append(item)
            }
        }
       
    }
    func parseNextShift () {
        print("There are \(nextShiftsArray.count) in the next shift array")
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
            officeLocationLbl.text = nextShift?.workPlaceName
            statusLbl.text = nextShift?.status
            shiftDateLbl.text = headerFormatter.string(from: nextShift!.startShiftDate!)
            startTimeLbl.text = dateFormatter.string(from: nextShift!.startShiftDate!)
            endTimeLbl.text = dateFormatter.string(from: nextShift!.endShiftDate!)
            shiftStatusFormatting(shiftStatus: nextShift!, view: statusView, oval: statusOval)
            shiftDurationLbl.text = dateCmpntsFormatter.string(from: nextShift!.startShiftDate!, to: nextShift!.endShiftDate!)
        }
    }
    
    
  
    
    
}


