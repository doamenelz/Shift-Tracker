//
//  SuccessModal.swift
//  My Shift Calculator
//
//  Created by Ed Em on 2019-04-02.
//  Copyright © 2019 Ed Em. All rights reserved.
//

import UIKit

class SuccessModal: UIViewController {

    //Variables
    
    var modalMessage: String?
    
    //Outlets
    @IBOutlet weak var successMsgLbl: UILabel!
    @IBOutlet weak var doneLbl: UIButton!
    @IBOutlet weak var modalView: UIView!
    
    
    //Actions
    @IBAction func donePressed(_ sender: Any) {
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        modalView.layer.cornerRadius = 13
        doneLbl.layer.cornerRadius = 5
        successMsgLbl.text = modalMessage
        // Do any additional setup after loading the view.
    }


}
