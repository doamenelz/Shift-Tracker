//
//  ChooseWorkPlaceModVC.swift
//  My Shift Calculator
//
//  Created by Ed Em on 2019-04-02.
//  Copyright © 2019 Ed Em. All rights reserved.
//

import UIKit

class ChooseWorkPlaceModVC: UIViewController {

    
    //Outlets
    @IBOutlet weak var modalView: UIView!
    @IBOutlet weak var manageView: UIView!
    @IBOutlet weak var newView: UIView!
    @IBOutlet weak var modalImg: UIImageView!
    
    //Actions
    @IBAction func newWorkPlaceBtnPressed(_ sender: Any) {
        
    }
    @IBAction func manageWorkPlacePressed(_ sender: Any) {
        
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newView.layer.cornerRadius = 5
        manageView.layer.cornerRadius = 5
        newView.layer.borderWidth = 0.2
        manageView.layer.borderWidth = 0.2
        manageView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        newView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
       
        
        modalImg.layer.cornerRadius = 15
        modalView.layer.cornerRadius = 15
        modalImg.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        modalImg.layer.masksToBounds = true
    }

    func setupView() {
        
    }
    
}
