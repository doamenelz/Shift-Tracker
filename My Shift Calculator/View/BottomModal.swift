//
//  BottomModal.swift
//  My Shift Calculator
//
//  Created by Ed Em on 2019-04-04.
//  Copyright © 2019 Ed Em. All rights reserved.
//

import UIKit
@IBDesignable
class BottomModal: UIView {

    
    override func prepareForInterfaceBuilder() {
        customizeModal()
    }
    
    override func awakeFromNib() {
        customizeModal()
    }
    func customizeModal () {
        
        self.layer.cornerRadius = 15
        self.layer.cornerRadius = 15
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        self.layer.masksToBounds = true
    }

}
