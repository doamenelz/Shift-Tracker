//
//  CreateShiftVC.swift
//  My Shift Calculator
//
//  Created by Ed Em on 2019-04-04.
//  Copyright © 2019 Ed Em. All rights reserved.
//

import UIKit

class CreateShiftVC: UIViewController {

    
    //Outlets
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var selectWorkPlace: CustomBtnSmallerModel!
    @IBOutlet weak var selectDate: CustomBtnSmallerModel!
    @IBOutlet weak var startTime: CustomBtnSmallerModel!
    @IBOutlet weak var endTime: CustomBtnSmallerModel!
    @IBOutlet weak var backGroundView: UIView!
    
    
    var borderWidth = 0.5
    var borderColor = #colorLiteral(red: 0.4274509804, green: 0.4745098039, blue: 0.5764705882, alpha: 1)
    
    
    
    //Actions
    @IBAction func addShiftPressed(_ sender: Any) {
        
    
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CreateShiftVC.handleTap(_:)))
        backGroundView.addGestureRecognizer(tapGesture)

    }
    //AddPicker
    
@objc func handleTap(_ sender: UITapGestureRecognizer) {
    resignFirstResponder()
    dismiss(animated: false, completion: nil)
}
}
