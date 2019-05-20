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
    var segueTag: Int?
    
    //Outlets
    @IBOutlet weak var successMsgLbl: UILabel!
    @IBOutlet weak var doneLbl: UIButton!
    @IBOutlet weak var modalView: UIView!
    
    
    //Actions
    @IBAction func donePressed(_ sender: Any) {
//        if segueTag == 2 {
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ManageWorkspace") as! ManageWorkspace
//        self.present(vc, animated: false, completion: nil)
//    } else {
//        dismiss(animated: true, completion: nil)
//    }
      dismiss(animated: true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        modalView.layer.cornerRadius = 13
        doneLbl.layer.cornerRadius = 5
        successMsgLbl.text = modalMessage
        //print(segueTag)
        // Do any additional setup after loading the view.
    }


}
