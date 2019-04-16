//
//  ShiftCell.swift
//  My Shift Calculator
//
//  Created by Ed Em on 2019-04-04.
//  Copyright © 2019 Ed Em. All rights reserved.
//

import UIKit

class ShiftCell: UITableViewCell {

    
    //Outlets
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var hrLblView: UIView!
    @IBOutlet weak var hrLbl: UILabel!
     var dateFormatter = DateFormatter()
    
    @IBOutlet weak var bgView: UIView!
    //Actions
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        hrLblView.layer.cornerRadius = 10
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureCell (shift: Shift) {
        hrLblView.layer.cornerRadius = 10
        dateFormatter.dateFormat = "E, d MMM"
        //dateLbl.text = shift.startShiftDate
        dateLbl.text = dateFormatter.string(from: shift.startShiftDate!)
        bgView.layer.cornerRadius = 5
        //hrLbl.text =
    }
}
