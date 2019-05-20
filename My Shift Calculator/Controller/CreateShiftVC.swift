//
//  CreateShiftVC.swift
//  My Shift Calculator
//
//  Created by Ed Em on 2019-04-04.
//  Copyright © 2019 Ed Em. All rights reserved.
//

import UIKit
import CoreData

class CreateShiftVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    //MARK: - CoreData Context
     let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        //var interactor:Interactor? = nil
 
    //MARK: - Outlets
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var selectWorkPlace: CustomBtnSmallerModel!
    @IBOutlet weak var selectDate: CustomBtnSmallerModel!
    @IBOutlet weak var startTime: CustomBtnSmallerModel!
    @IBOutlet weak var backGroundView: UIView!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var bottomModal: BottomModal!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var doneView: UIButton!
    
    //MARK: - Variables
    var pickerData = [String]()
    var workPlaceArray = [Workplace]()
    var modalDisplay = ""
    var selectedWorkplace = ""
    var startShiftDate: Date!
    var endShiftDate = Date()
    var rateToSave: Double!
    var pickerRow = ""
    var tag: Int = 0
    var dateFormatter = DateFormatter()
    var rates: [Double]?
 
    //MARK: - Actions
    
    
    @IBAction func addShiftPressed(_ sender: Any) {
        picker.isHidden = true
        datePicker.isHidden = true
        
        if (startShiftDate < endShiftDate) && (selectedWorkplace != "") {
           
            //Parse  to Context
           let newShift = Shift(context: self.context)
            newShift.startShiftDate = startShiftDate
            newShift.endShiftDate = endShiftDate
           newShift.workPlaceName = selectedWorkplace
            newShift.rates = rateToSave
            newShift.status = ShiftStatus(rawValue: "Scheduled").map { $0.rawValue }
            saveShift()
            let title = "Shift Created!"
            confirmAction(title: title)
        } else {
            print("Conditions failed")
        }
    }
    
    @IBAction func donePressed(_ sender: Any) {
        
        picker.isHidden = true
        datePicker.isHidden = true
        doneView.isHidden = true
        
         let tempDate = Date(timeIntervalSinceReferenceDate: (datePicker.date.timeIntervalSinceReferenceDate / 300.0).rounded(.down) * 300.0)
        let formatedDate = dateFormatter.string(from: tempDate)
        if tag == 3 {
            selectDate.setTitle(formatedDate, for: .normal)
            let roundedDate = Date(timeIntervalSinceReferenceDate: (datePicker.date.timeIntervalSinceReferenceDate / 300.0).rounded(.down) * 300.0)
            startShiftDate = roundedDate

        } else if tag == 4 {
            startTime.setTitle(formatedDate, for: .normal)
            let roundedDate = Date(timeIntervalSinceReferenceDate: (datePicker.date.timeIntervalSinceReferenceDate / 300.0).rounded(.down) * 300.0)
            endShiftDate = roundedDate
            print("End date is \(endShiftDate)")
            print("Start date is \(tag)")

        }

    }
    
    @IBAction func selectWorkPlacePressed(_ sender: Any) {
//        var workplacePickerData = [String]()
            var wPR : [Double] = [0]
//
//        //Parse Workplaces to Picker
//        for item in workPlaceArray {
//            workplacePickerData.append(item.workPlaceName ?? "nil")
//        }
//        pickerData = workplacePickerData
        
        //Pull Rates from Context
        for rates in workPlaceArray {
        wPR.append(rates.rates)
        }
        rates = wPR
       
        datePicker.isHidden = true
        doneView.isHidden = false
        picker.isHidden = false

    }
    
    @IBAction func startDateSelected(_ sender: Any) {
      doneView.isHidden = false
        selectDatePicker()
        tag = 3
    }
    
    @IBAction func endTimeSelected(_ sender: Any) {
       doneView.isHidden = false
        datePicker.reloadInputViews()
        selectDatePicker()
        tag = 4
    }
    
     override func viewDidLoad() {
        super.viewDidLoad()
        self.picker.delegate = self
        self.picker.dataSource = self
        setupView()
        loadWorkplace()
        var workplacePickerData = [String]()
        
        //Parse Workplaces to Picker
        for item in workPlaceArray {
            workplacePickerData.append(item.workPlaceName ?? "nil")
        }
        pickerData = workplacePickerData
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CreateShiftVC.handleTap(_:)))
        backGroundView.addGestureRecognizer(tapGesture)
    }
    
    //MARK: - PickerView Methods
    
    //Delegates
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        
        pickerRow = pickerData[row] //as? String ?? ""
       return pickerData[row] // as? String
    }
    
    //Datasource
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedWorkplace = pickerData[row]
        selectWorkPlace.setTitle(selectedWorkplace, for: .normal)
        
        let wkPIndex = pickerData.firstIndex(of: selectedWorkplace)
        print(pickerData)
        print(rates!)
        rateToSave = rates![wkPIndex!]
    }
    
    //TapGesture
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
    resignFirstResponder()
    dismiss(animated: false, completion: nil)
}

    //MARK:- Data Manipulation Methods
    func loadWorkplace () {
        let request : NSFetchRequest<Workplace> = Workplace.fetchRequest()
        do {
            //ParseWorkplace to Array
            workPlaceArray =  try context.fetch(request)
            print("Workplace Array is \(workPlaceArray)")
        } catch  {
            print("Error fetching Workplace from context \(error)")
        }
        
    }
    
    func selectDatePicker () {
        picker.isHidden = true
        datePicker.isHidden = false
       
    }
  
    func setupView() {
        datePicker.layer.cornerRadius = 5
        datePicker.layer.borderWidth = 0.3
        datePicker.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        
        picker.layer.cornerRadius = 5
        picker.layer.borderWidth = 0.3
        picker.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        
        bottomModal.translatesAutoresizingMaskIntoConstraints = false
        picker.isHidden = true
        datePicker.isHidden = true
        dateFormatter.dateFormat = "EEEE, MMM d, h:mm a"
        doneView.isHidden = true
        
    }

    func saveShift() {
        do {
            try context.save()
            print("Context Saved! \(context)")
            modalDisplay = "Shift was created successfully!"
        } catch {
            print("Error saving context \(error)")
        }
        
    }

}
