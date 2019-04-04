//
//  Home.swift
//  My Shift Calculator
//
//  Created by Ed Em on 2019-04-01.
//  Copyright © 2019 Ed Em. All rights reserved.
//

import UIKit
@IBDesignable
class Home: UIViewController {

    //Variables
    
    //Outlets
   
    @IBOutlet weak var dashBoardView: UIImageView!
    
    @IBOutlet weak var dashboardView: UIView!
    @IBOutlet weak var viewAllBtn: UIButton!
    @IBOutlet weak var addShiftBtn: CustomizeBtn!
    @IBOutlet weak var shiftDateLbl: UILabel!
    @IBOutlet weak var officeLocationLbl: UILabel!
    @IBOutlet weak var shiftPeriodLbl: UILabel!
    @IBOutlet weak var startTimeLbl: UILabel!
    @IBOutlet weak var endTimeLbl: UILabel!
    @IBOutlet weak var durationDescription: UILabel!
    @IBOutlet weak var clockBtn: CustomizeBtn!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var statusOval: UIImageView!
    
    @IBOutlet weak var shiftView: UIView!
    @IBOutlet weak var topBorderView: UIView!
    
    
    //Actions
    @IBAction func settings(_ sender: Any) {
        
    }
    
    @IBAction func viewAllPressed(_ sender: Any) {
    }
    
    @IBAction func addShiftPressed(_ sender: Any) {
        
    }
    @IBAction func clockButtonPressed(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        // Do any additional setup after loading the view.
    }
    
    func setUpView () {
       
        //DashBoard Adjustments
        dashboardView.layer.cornerRadius = 13
        dashBoardView.layer.cornerRadius = 13
        self.dashboardView.layer.shadowColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        self.dashboardView.layer.shadowOpacity = 0.6
        self.dashboardView.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.dashboardView.layer.shadowRadius = 2
        self.dashBoardView.layer.masksToBounds = true
 
        //ShiftView Adjustments
        shiftView.layer.cornerRadius = 13
        shiftView.layer.borderWidth = 0.2
        shiftView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        topBorderView.layer.cornerRadius = 13
        topBorderView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
}


