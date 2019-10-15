//
//  AlertDialog.swift
//  ShotClock
//
//  Created by Nobuhiro Harada on 2019/10/07.
//  Copyright © 2019 Nobuhiro Harada. All rights reserved.
//

import Foundation
import UIKit

class AlertDialog: UIAlertController {
    
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
    
    static func selectAlertController(action: UIAlertAction) -> UIAlertAction {
        
        action.setValue(UIImage(named: "checkmark.png")?.scaleImage(scaleSize: 0.4), forKey: "image")
        
        return action
    }
    
    class func showSettingActionSheet(_ shotClockView: ShotClockView, viewController: UIViewController) {
        
        let actionSheet: UIAlertController = UIAlertController(title: "setting_title".localized,  message: "setting_subtitle".localized, preferredStyle:  UIAlertController.Style.actionSheet)
        
        var autoBuzzerAction = UIAlertAction(title: "setting_auto_buzzer".localized, style: UIAlertAction.Style.default, handler:{
            (action: UIAlertAction!) -> Void in
            
            if userdefaults.bool(forKey: BUZEER_AUTO_BEEP) {
                userdefaults.set(false, forKey: BUZEER_AUTO_BEEP)
            } else {
                userdefaults.set(true, forKey: BUZEER_AUTO_BEEP)
            }
            
        })
        
        let initAction = UIAlertAction(title: "setting_reset".localized, style: UIAlertAction.Style.default, handler:{
            (action: UIAlertAction!) -> Void in
            
            shotClockView.reset()

        })
        
        let cancelAction = UIAlertAction(title: "setting_cancel".localized, style: UIAlertAction.Style.cancel, handler: nil)
        
        if userdefaults.bool(forKey: BUZEER_AUTO_BEEP) {
            autoBuzzerAction = selectAlertController(action: autoBuzzerAction)
        }
        
        actionSheet.addAction(autoBuzzerAction)
        actionSheet.addAction(initAction)
        actionSheet.addAction(cancelAction)
        
        actionSheet.popoverPresentationController?.sourceView = viewController.view
        
        let screenSize = UIScreen.main.bounds
        actionSheet.popoverPresentationController?.sourceRect = CGRect(x: screenSize.size.width/2, y: screenSize.size.height, width: 0, height: 0)
        
        viewController.present(actionSheet, animated: true, completion: nil)
    }
}
