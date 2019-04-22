//
//  CustomBtnSmallerModel.swift
//  My Shift Calculator
//
//  Created by Ed Em on 2019-04-02.
//  Copyright © 2019 Ed Em. All rights reserved.
//

import UIKit

class CustomBtnSmallerModel: UIButton {

  
    override func prepareForInterfaceBuilder() {
        customizeBtn()
    }
    
    override func awakeFromNib() {
        customizeBtn()
    }
    
    func customizeBtn () {
        layer.cornerRadius =  5
        layer.shadowRadius = 0.3
        layer.shadowColor = #colorLiteral(red: 0.4274509804, green: 0.4745098039, blue: 0.5764705882, alpha: 1)
        layer.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        layer.borderWidth = 0.5
        
    }

}
