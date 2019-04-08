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

    //Outlets
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var selectWorkPlace: CustomBtnSmallerModel!
    @IBOutlet weak var selectDate: CustomBtnSmallerModel!
    @IBOutlet weak var startTime: CustomBtnSmallerModel!
    @IBOutlet weak var endTime: CustomBtnSmallerModel!
    @IBOutlet weak var backGroundView: UIView!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var bottomModal: BottomModal!
    
    
    //Variables
    var pickerData = [Any]()
    var workPlaceArray = [Workplace]()

    var borderWidth = 0.5
    var borderColor = #colorLiteral(red: 0.4274509804, green: 0.4745098039, blue: 0.5764705882, alpha: 1)
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedWorkplace = ""
    var selectedDate = ""
    
    //PickerDataVariables
    var pickerRow = ""
    var tag: Int = 0
    var numberOfComponents: Int = 0
    
    //Actions
    @IBAction func addShiftPressed(_ sender: Any) {
        picker.isHidden = false
    
    }
    @IBAction func selectWorkPlacePressed(_ sender: Any) {
        tag = 1
        numberOfComponents = 1
        loadWorkplace()
        
        //Compare old and new workplace or make workplace unique
            var workplacePickerData = [String]()
        for items in workPlaceArray {
                workplacePickerData.append(items.workPlaceName ?? "nil")
            }
          pickerData = workplacePickerData
          picker.isHidden = false
          picker.reloadAllComponents()
        print("picker data = \(pickerData)")
    }
    
    @IBAction func selectDatePressed(_ sender: Any) {
//        tag = 2
//        numberOfComponents = 2
//        picker.isHidden = true
//        pickerData = [["New Date et al", "Other things to do for men"], ["1", "Other Number"]]
//        picker.isHidden = false
//        picker.reloadAllComponents()
//
//
//        print(pickerData)
    }
    
    @IBAction func startTimeSelected(_ sender: Any) {
     
        
    }
    
    @IBAction func stopTimeSelected(_ sender: Any) {
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CreateShiftVC.handleTap(_:)))
        backGroundView.addGestureRecognizer(tapGesture)

        self.picker.delegate = self
        self.picker.dataSource = self
        bottomModal.translatesAutoresizingMaskIntoConstraints = false
        picker.isHidden = true
    }
    //AddPicker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return numberOfComponents
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
           pickerRow = pickerData[row] as? String ?? "nil"
        return pickerData[row] as? String
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        if tag == 1 {
            selectedWorkplace = pickerRow
            selectWorkPlace.setTitle(selectedWorkplace, for: .normal)
        } else if tag == 2 {
            selectedDate = pickerRow
            selectDate.setTitle(selectedDate, for: .normal)
        } else if tag == 3 {
        
        }
       
    }
    
@objc func handleTap(_ sender: UITapGestureRecognizer) {
    resignFirstResponder()
    dismiss(animated: false, completion: nil)
}

//LoadItems
    func loadWorkplace () {
        let request : NSFetchRequest<Workplace> = Workplace.fetchRequest()
        do {
            //ParseWorkplace to Array
            workPlaceArray =  try context.fetch(request)
            print("Workplace successfully loaded")
        } catch  {
            print("Error fetching Workplace from context \(error)")
        }
        
    }
    




}
