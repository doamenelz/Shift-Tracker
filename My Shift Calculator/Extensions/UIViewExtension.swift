//
//  UIViewExtension.swift
//  My Shift Calculator
//
//  Created by Ed Em on 2019-04-18.
//  Copyright © 2019 Ed Em. All rights reserved.
//

import UIKit

    extension UIViewController {
        func bindToKeyboard () {
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        }
       
        @objc func keyboardWillShow(notification: NSNotification) {
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                if self.view.frame.origin.y == 0 {
                    self.view.frame.origin.y -= keyboardSize.height
                }
            }
        }
        
        @objc func keyboardWillHide(notification: NSNotification) {
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y = 0
            }
        }
        
        open func shiftStatusFormatting (shiftStatus: Shift, view: UIView, oval: UIImageView) {
            switch shiftStatus.status {
            case "Completed":
                view.backgroundColor = UIColorFromHex(rgbValue: 0x6DB871, alpha: 1)
                oval.image = UIImage(named: "Active Oval")
            case "Cancelled":
                view.backgroundColor = UIColorFromHex(rgbValue: 0xC51E2E, alpha: 1)
                oval.image = UIImage(named: "cancelledOval")
            case "Scheduled":
                view.backgroundColor = UIColorFromHex(rgbValue: 0x00DEFF, alpha: 1)
                oval.image = UIImage(named: "scheduledOval")
            default:
                print("Color is something else")
            }
        }

        func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
            let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
            let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
            let blue = CGFloat(rgbValue & 0xFF)/256.0
            
            return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
        }
    }

