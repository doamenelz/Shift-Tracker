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

    
     let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //Outlets
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var selectWorkPlace: CustomBtnSmallerModel!
    @IBOutlet weak var selectDate: CustomBtnSmallerModel!
    @IBOutlet weak var startTime: CustomBtnSmallerModel!
   // @IBOutlet weak var endTime: CustomBtnSmallerModel!
    @IBOutlet weak var backGroundView: UIView!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var bottomModal: BottomModal!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var doneView: UIButton!
    
    
    //Variables
    var pickerData = [Any]()
    var workPlaceArray = [Workplace]()
    
    
    var borderWidth = 0.5
    var borderColor = #colorLiteral(red: 0.4274509804, green: 0.4745098039, blue: 0.5764705882, alpha: 1)
   
    var selectedWorkplace = ""
    var startShiftDate: Date!
    var endShiftDate = Date()
    
    //PickerDataVariables
    var pickerRow = ""
    var tag: Int = 0
    var numberOfComponents: Int = 0
    var dateFormatter = DateFormatter()

    
    //Actions
    @IBAction func valueChanged(_ sender: Any) {
           let formatedDate = dateFormatter.string(from: datePicker.date)
        if tag == 3 {
             selectDate.setTitle(formatedDate, for: .normal)
            startShiftDate = datePicker.date
            print(startShiftDate)
        } else if tag == 4 {
             startTime.setTitle(formatedDate, for: .normal)
            datePicker.minimumDate = startShiftDate
            endShiftDate = datePicker.date
            print(endShiftDate)
        }
     
       
    }
    @IBAction func addShiftPressed(_ sender: Any) {
        picker.isHidden = true
        datePicker.isHidden = true
        
        if (startShiftDate < endShiftDate) && (selectedWorkplace != "") {
            
            print("All conditions passed")
            
            //Persist Data()
           
            
        } else {
            print("Conditions failed")
        }
        //check if value are entered
        
        //check if minimum is <= max then drop else persist to coredata
        
    
    }
    @IBAction func donePressed(_ sender: Any) {
        picker.isHidden = true
        datePicker.isHidden = true
        doneView.isHidden = true
        let formatedDate = dateFormatter.string(from: datePicker.date)
        if tag == 3 {
            selectDate.setTitle(formatedDate, for: .normal)
            startShiftDate = datePicker.date
        }
        
//        if tag == 1 {
//            if selectWorkPlace.titleLabel?.text == "" {
//                print("No value found")
//            } else {
//                selectWorkPlace.setTitle(selectedWorkplace, for: .normal)
//                print("too bsddd")
//                print(selectedWorkplace.description)
//                print(selectWorkPlace.titleLabel?.text)
//            }
//
//        }
       

    }
    @IBAction func selectWorkPlacePressed(_ sender: Any) {
        tag = 1
        //numberOfComponents = 1
        loadWorkplace()

        var workplacePickerData = ["-- Select a Workplace --"]
        for items in workPlaceArray {
                workplacePickerData.append(items.workPlaceName ?? "nil")
            }
        
        pickerData = workplacePickerData
        datePicker.isHidden = true
        doneView.isHidden = false
        picker.isHidden = false

    }
    
    @IBAction func selectDatePressed(_ sender: Any) {
      doneView.isHidden = false
        selectDatePicker()
        tag = 3
        
        
        //print(startShiftDate)
    }
    
    @IBAction func startTimeSelected(_ sender: Any) {
       doneView.isHidden = false
        datePicker.reloadInputViews()
        selectDatePicker()
        tag = 4
  
       // print(endShiftDate)
    }
     override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CreateShiftVC.handleTap(_:)))
        backGroundView.addGestureRecognizer(tapGesture)

        self.picker.delegate = self
        self.picker.dataSource = self
        bottomModal.translatesAutoresizingMaskIntoConstraints = false
        picker.isHidden = true
        datePicker.isHidden = true
        dateFormatter.dateFormat = "EEEE, MMM d, h:mm a"
        doneView.isHidden = true
        setupView()
        
    }
    
    //MARK: - AddPicker Stubs
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
           pickerRow = pickerData[row] as? String ?? ""
        return pickerData[row] as? String
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            selectedWorkplace = pickerData[row] as? String ?? "Select Workplace"
            selectWorkPlace.setTitle(selectedWorkplace, for: .normal)
       
    }
    
@objc func handleTap(_ sender: UITapGestureRecognizer) {
    resignFirstResponder()
    dismiss(animated: false, completion: nil)
}

    //MARK:- CoreData Functions
    func loadWorkplace () {
        let request : NSFetchRequest<Workplace> = Workplace.fetchRequest()
        do {
            //ParseWorkplace to Array
            workPlaceArray =  try context.fetch(request)
            print(workPlaceArray)
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
        
    }

    func saveShift() {
        do {
            try context.save()
            print("Context Saved! \(context)")
            //modalDisplay = "Workplace was added successfully!"
        } catch {
            print("Error saving context \(error)")
        }
        
    }
    //Persist the date and time
    // Enforce Minimum stuff
    



}
