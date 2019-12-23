//
//  AlertDialog.swift
//  ShotClock
//
//  Created by Nobuhiro Harada on 2019/10/07.
//  Copyright © 2019 Nobuhiro Harada. All rights reserved.
//

import Foundation
import UIKit

final class AlertDialog: UIAlertController {
    
    class func showTimeover(title: String, viewController: UIViewController, callback: @escaping () -> Void) {
        
        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(okAction)
        viewController.present(alert, animated: true, completion: callback)
    }
    
    class func showShotClockEdit(title: String, shotClockView: ShotClockView, viewController: UIViewController) {
        
        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
            if let textFields = alert.textFields {
                
                for textField in textFields {
                    if textField.text != "" {
                        shotClockView.shotClockLabel.text = textField.text
                        shotClockView.shotSeconds = Int(textField.text!)!
                    }
                }
            }
        }
        
        alert.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        alert.addTextField(configurationHandler: {(textField: UITextField!) -> Void in
            textField.placeholder = String(0)
            textField.text = shotClockView.shotClockLabel.text
            textField.keyboardType = UIKeyboardType.numberPad
        })
        viewController.present(alert, animated: true, completion: nil)
    }
    
    static func setSelectShotClockColor(action: UIAlertAction, color: UIColor) -> UIAlertAction {
            
        action.setValue(UIImage(named: "checkmark.png")?.scaleImage(scaleSize: 0.4), forKey: "image")
        action.setValue(color, forKey: "imageTintColor")
        action.setValue(color, forKey: "titleTextColor")
        
        return action
    }
}
