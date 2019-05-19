//
//  ShiftExpandedMonthViewVC.swift
//  My Shift Calculator
//
//  Created by Ed Em on 2019-05-18.
//  Copyright © 2019 Ed Em. All rights reserved.
//

import UIKit
import iOSDropDown
import CoreData


class ShiftExpandedMonthViewVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
 
    

     let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //Outlets
    @IBOutlet weak var dropDown: DropDown!
    @IBOutlet weak var summaryView: UIView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var earnedAmtMnth: UILabel!
    @IBOutlet weak var workedAmnt: UILabel!
    @IBOutlet weak var workPlaceCount: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var switchBtn: CustomizeBtn!
    
    
    //Variables
    var shiftsLoaded = [Shift]()
    var monthShift = [Shift]()
    var lastDayOfMonth = Date()
    var firstDayOfMonth = Date()
    let calendar = Calendar.current
    var monthInText = ""
    var monthInInt = 0


    var dateComponents = DateComponents()
    
    var actualEarningsArray = [Double]()
    var actualEarnings: Double?
    
    var actualWorkedHoursArray = [Double]()
    var actualWorkedHours: Double?
    var workPlaces = [String]()
    
    //let  dropDown = DropDown(frame: CGRect(x: 110, y: 140, width: 200, height: 30))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        tableView.dataSource = self
        tableView.delegate = self
        loadShiftsFromContext()
        print(shiftsLoaded.count)
       getMonthShifts(selectedDate: Date())
        actualWorkedHours = actualWorkedHoursArray.reduce(0, +)
        workedAmnt.text = "\(actualWorkedHours!) Hrs"
        actualEarnings = actualEarningsArray.reduce(0, +)
        earnedAmtMnth.text = "\(actualEarnings!)"
        workPlaceCount.text = "\(Array(Set(workPlaces)).count)"
        actualEarningsArray = []
        actualWorkedHoursArray = []
        workPlaces = []

    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return monthShift.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ShiftCell", for: indexPath) as? MonthlyViewCell {
            cell.configureCell(shift: monthShift[indexPath.row])
            shiftStatusFormatting(shiftStatus: monthShift[indexPath.row], view: cell.statusView, oval: cell.statusOval)
            return cell
        }
        return UITableViewCell()
    }
    
    func setupView() {
        summaryView.layer.cornerRadius = 10
     //   summaryView.layer.shadowColor = UIColor.black.cgColor
        summaryView.layer.shadowColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        summaryView.layer.shadowOpacity = 9
        summaryView.layer.shadowOffset = .init(width: 0, height: 2)
        summaryView.layer.shadowRadius = 2
        switchBtn.backgroundColor = #colorLiteral(red: 0.4274509804, green: 0.4745098039, blue: 0.5764705882, alpha: 1)
        //calendar.
        
        
         dropDown.optionArray = calendar.monthSymbols
        print(dropDown.optionArray)
        dropDown.listWillAppear {
            self.summaryView.isHidden = true
           self.tableView.isHidden = true
        }
        dropDown.listDidDisappear {
            self.summaryView.isHidden = false
            self.tableView.isHidden = false
            //self.tableView.reloadData()
        }
        dropDown.didSelect { (selectedText, index, id) in
            print("Selected String: \(selectedText) \n index: \(index)")
            self.monthShift = []
            self.actualEarningsArray = []
            self.actualWorkedHoursArray = []
            self.workPlaces = []
            self.monthInText = selectedText
            self.monthInInt = index
            self.getMonthsString(monthInText: selectedText)
            self.getMonthShifts(selectedDate: self.firstDayOfMonth)
            self.actualEarnings = self.actualEarningsArray.reduce(0, +)
            self.actualWorkedHours = self.actualWorkedHoursArray.reduce(0, +)
            self.earnedAmtMnth.text = "\(self.actualEarnings!)"
            self.workedAmnt.text = "\(self.actualWorkedHours!) Hrs"
            self.workPlaceCount.text = "\(Array(Set(self.workPlaces)).count)"
            self.tableView.reloadData()
            print(self.firstDayOfMonth)
        }
        
    }
    
    func loadWorkplace () {
        
    }
    
    func getMonthsString (monthInText: String) {
        let month: String = monthInText
        var selectedMonth: Int?

        dateComponents.year = calendar.component(.year, from: Date())
        //dateComponents.month = selectedMonth
        dateComponents.day = 10
        switch month {
        case "January":
            selectedMonth = 1
            dateComponents.month = selectedMonth
            firstDayOfMonth = calendar.date(from: dateComponents)!
        case "February":
            selectedMonth = 2
            dateComponents.month = selectedMonth
            firstDayOfMonth = calendar.date(from: dateComponents)!
        case "March":
            selectedMonth = 3
            dateComponents.month = selectedMonth
            firstDayOfMonth = calendar.date(from: dateComponents)!
        case "April":
            selectedMonth = 4
            dateComponents.month = selectedMonth
              firstDayOfMonth = calendar.date(from: dateComponents)!
            print("I can see \(firstDayOfMonth) as the month")
        case "May":
            selectedMonth = 5
            dateComponents.month = selectedMonth
            firstDayOfMonth = calendar.date(from: dateComponents)!
            print("I can see \(firstDayOfMonth) as the month")
        case "June":
            selectedMonth = 6
            dateComponents.month = selectedMonth
            firstDayOfMonth = calendar.date(from: dateComponents)!
        case "July":
            selectedMonth = 7
            dateComponents.month = selectedMonth
            firstDayOfMonth = calendar.date(from: dateComponents)!
        case "August":
            selectedMonth = 8
             firstDayOfMonth = calendar.date(from: dateComponents)!
            dateComponents.month = selectedMonth
            print("I can see \(firstDayOfMonth) as the month")
        case "September":
            selectedMonth = 9
            dateComponents.month = selectedMonth
            firstDayOfMonth = calendar.date(from: dateComponents)!
        case "October":
            selectedMonth = 10
            dateComponents.month = selectedMonth
            firstDayOfMonth = calendar.date(from: dateComponents)!
        case "November":
            selectedMonth = 11
            dateComponents.month = selectedMonth
            firstDayOfMonth = calendar.date(from: dateComponents)!
        case "December":
            selectedMonth = 12
            dateComponents.month = selectedMonth
            firstDayOfMonth = calendar.date(from: dateComponents)!
        default:
            break
        }
        
        tableView.reloadData()
        
    }
    
    func getMonthShifts (selectedDate: Date) {
        let startDate = selectedDate.startOfMonth()
        let endDate = selectedDate.endOfMonth()
        let monthRange = startDate...endDate
       
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM, yyyy"
        monthLabel.text = dateFormatter.string(from: selectedDate)
        
        
        for item in shiftsLoaded {
             if monthRange.contains(item.startShiftDate!) {
                monthShift.append(item)
                    
                    let tempRate = item.rates
                    let minuteDifferential = item.endShiftDate?.timeIntervalSince(item.startShiftDate!)
                    let secondsToMins = (round(100 * (minuteDifferential! / 3600)) / 100)
                    let earnedAmountPerDay = tempRate * secondsToMins
                    let tempStatus = ShiftStatus.completed.status()
                    if item.status == tempStatus {
                        actualEarningsArray.append(earnedAmountPerDay)
                        actualWorkedHoursArray.append(Double(secondsToMins))
                        workPlaces.append(item.workPlaceName!)
                    }
            }
        }
    }
    
    func loadShiftsFromContext () {
        let request : NSFetchRequest<Shift> = Shift.fetchRequest()
        let sort = NSSortDescriptor(key: "startShiftDate", ascending: true)
        request.sortDescriptors = [sort]
        do {
            shiftsLoaded = try context.fetch(request)
            print("----------------AllLoadedWithContext-----------------")
        } catch {
            print("Error fetching request \(error)")
        }
    }
    
    
}
