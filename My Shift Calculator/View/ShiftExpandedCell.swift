//
//  ShiftExpandedCell.swift
//  My Shift Calculator
//
//  Created by Ed Em on 2019-04-15.
//  Copyright © 2019 Ed Em. All rights reserved.
//

import UIKit
@IBDesignable
class ShiftExpandedCell: UITableViewCell {

    
    //Outlets
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var shiftStartLbl: UILabel!
    @IBOutlet weak var shiftEndLabel: UILabel!
    @IBOutlet weak var shiftDurationLbl: UILabel!
    @IBOutlet weak var ratesLabel: UILabel!
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var statusOval: UIImageView!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var shiftDay: UILabel!
    
    
    //Variables
     var dateFormatter = DateFormatter()
    var headerFormatter = DateFormatter()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        statusView.layer.cornerRadius = 10
        cellView.layer.cornerRadius = 10
        cellView.layer.shadowColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell (shift: Shift) {
        dateFormatter.dateFormat = "MMM d, h:mm a"
        headerFormatter.dateFormat = "E, MMM d"
        let dateComponentsFormatter = DateComponentsFormatter()
        dateComponentsFormatter.allowedUnits = [.day,.hour, .minute]
        dateComponentsFormatter.maximumUnitCount = 2
        dateComponentsFormatter.unitsStyle = .brief
        dateComponentsFormatter.string(from: Date(), to: Date(timeIntervalSinceNow: 4000000))
        
        shiftStartLbl.text = dateFormatter.string(from: shift.startShiftDate!)
        shiftEndLabel.text = dateFormatter.string(from: shift.endShiftDate!)
        locationLabel.text = shift.workPlaceName
        ratesLabel.text = "$\(shift.rates) / hr"
        shiftDurationLbl.text = dateComponentsFormatter.string(from: shift.startShiftDate!, to: shift.endShiftDate!)
        shiftDay.text = headerFormatter.string(from: shift.startShiftDate!)
        //print(shiftDateDifference)

    }

}

extension Date {
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour,.minute], from: date, to: self).hour ?? 0
    }
}
