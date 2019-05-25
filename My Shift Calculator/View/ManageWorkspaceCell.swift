//
//  ManageWorkspaceCell.swift
//  My Shift Calculator
//
//  Created by Ed Em on 2019-05-14.
//  Copyright © 2019 Ed Em. All rights reserved.
//

import UIKit
import CoreData

class ManageWorkspaceCell: UITableViewCell {

    //Variables
    var dateFormatter = DateFormatter()
    
    //Outlets
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var ratesAmt: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var createdDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellView.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(workPlace: Workplace) {
        dateFormatter.dateFormat = "MMM d, h:mm a"
        locationLbl.text = workPlace.workPlaceName
        ratesAmt.text = "$\(String(workPlace.rates)) / Hr"
        createdDate.text = "\(dateFormatter.string(from: workPlace.dateCreated ?? Date()))"
    }

}
