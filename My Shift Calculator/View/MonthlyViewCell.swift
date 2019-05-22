//
//  MonthlyViewCell.swift
//  My Shift Calculator
//
//  Created by Ed Em on 2019-05-18.
//  Copyright © 2019 Ed Em. All rights reserved.
//

import UIKit
@IBDesignable
class MonthlyViewCell: UITableViewCell {

    //Outlets
    @IBOutlet weak var shiftStartLbl: UILabel!
    @IBOutlet weak var shiftEndLbl: UILabel!
    @IBOutlet weak var shiftDateLbl: UILabel!
    @IBOutlet weak var ratesLbl: UILabel!
    @IBOutlet weak var shiftDurationLbl: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var statusOval: UIImageView!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var statusView: UIView!
    
    //Variables
    var dateFormatter = DateFormatter()
    var headerFormatter = DateFormatter()
    let dateCmpntsFormatter = DateComponentsFormatter()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        statusView.layer.cornerRadius = 10
        cellView.layer.cornerRadius = 10
        cellView.layer.shadowColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell (shift: Shift) {
        dateFormatter.dateFormat = "MMM d, h:mm a"
        headerFormatter.dateFormat = "E, MMM d"
        dateCmpntsFormatter.dateComponentsFormatter(dateComponentsFormatter: dateCmpntsFormatter)
        
        //Parsing Shift to Labels
        shiftStartLbl.text = dateFormatter.string(from: shift.startShiftDate!)
        shiftEndLbl.text = dateFormatter.string(from: shift.endShiftDate!)
        locationLabel.text = shift.workPlaceName
        ratesLbl.text = "$\(shift.rates) / hr"
        shiftDurationLbl.text = dateCmpntsFormatter.string(from: shift.startShiftDate!, to: shift.endShiftDate!)
        shiftDateLbl.text = headerFormatter.string(from: shift.startShiftDate!)
        statusLbl.text = shift.status
        
        
    }
    
    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    
}
