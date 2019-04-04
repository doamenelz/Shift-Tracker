//
//  CustomTxtField.swift
//  My Shift Calculator
//
//  Created by Ed Em on 2019-04-02.
//  Copyright © 2019 Ed Em. All rights reserved.
//

import UIKit
@IBDesignable
class CustomTxtField: UITextField {

    override func prepareForInterfaceBuilder() {
        customizeTextField()
    }
    
    override func awakeFromNib() {
        customizeTextField()
    }
    
    func customizeTextField () {
//        backgroundColor = #colorLiteral(red: 0.9646341193, green: 0.9708352551, blue: 1, alpha: 0.2504548373)
        layer.cornerRadius = 2.0
        layer.borderWidth = 0.2
        layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        textAlignment = .center
        backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        if let phd = placeholder{
            let place = NSAttributedString(string: phd, attributes: [.foregroundColor : #colorLiteral(red: 0.4274509804, green: 0.4745098039, blue: 0.5764705882, alpha: 1)])
            attributedPlaceholder = place
            textColor = #colorLiteral(red: 0.4274509804, green: 0.4745098039, blue: 0.5764705882, alpha: 1)
        }
        
    }

}
