//
//  CustomizeBtn.swift
//  My Shift Calculator
//
//  Created by Ed Em on 2019-04-02.
//  Copyright © 2019 Ed Em. All rights reserved.
//

import UIKit
@IBDesignable
class CustomizeBtn: UIButton {

  
    override func prepareForInterfaceBuilder() {
        customizeBtn()
    }
    
    override func awakeFromNib() {
        customizeBtn()
    }
    
    func customizeBtn () {
        layer.cornerRadius =  15
        layer.shadowRadius = 5
        layer.shadowColor = #colorLiteral(red: 0.4274509804, green: 0.4745098039, blue: 0.5764705882, alpha: 1)
        
    }

}
