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
    
    class func showColorSettingActionSheet( _ shotClockView: ShotClockView, _ tableView: UITableView, _ indexPosition: IndexPath, viewController: UIViewController) {
        
        let colorState: ShotClockTextColor = userdefaults.getShotClockColor(forKey: SHOT_CLOCK_CHAR_CLOLR) ?? ShotClockTextColor.yellow
        
        let currentColor = shotClockView.shotClockLabel.getTextColor()
        
        let actionSheet: UIAlertController = UIAlertController(title: "setting_color_title".localized,  message: "setting_color_subtitle".localized, preferredStyle:  UIAlertController.Style.actionSheet)
        
        var redSelectedAction = UIAlertAction(title: "setting_red".localized, style: UIAlertAction.Style.default, handler:{
            (action: UIAlertAction!) -> Void in
            
            shotClockView.shotClockLabel.textColor = .red
            userdefaults.setShotClockColor(.red, forKey: SHOT_CLOCK_CHAR_CLOLR)
            tableView.reloadRows(at: [indexPosition], with: .none)
        })
        
        var greenSelectedAction = UIAlertAction(title: "setting_green".localized, style: UIAlertAction.Style.default, handler:{
            (action: UIAlertAction!) -> Void in
            
            shotClockView.shotClockLabel.textColor = .green
            userdefaults.setShotClockColor(.green, forKey: SHOT_CLOCK_CHAR_CLOLR)
            tableView.reloadRows(at: [indexPosition], with: .none)
        })
        
        var yellowSelectedAction = UIAlertAction(title: "setting_yellow".localized, style: UIAlertAction.Style.default, handler:{
            (action: UIAlertAction!) -> Void in
            
            shotClockView.shotClockLabel.textColor = .yellow
            userdefaults.setShotClockColor(.yellow, forKey: SHOT_CLOCK_CHAR_CLOLR)
            tableView.reloadRows(at: [indexPosition], with: .none)
        })
        
        let cancelAction = UIAlertAction(title: "setting_cancel".localized, style: UIAlertAction.Style.cancel, handler: nil)
        
        switch colorState {
        case .red:
            redSelectedAction = setSelectShotClockColor(action: redSelectedAction, color: currentColor)
        case .green:
            greenSelectedAction = setSelectShotClockColor(action: greenSelectedAction, color: currentColor)
        case .yellow:
            yellowSelectedAction = setSelectShotClockColor(action: yellowSelectedAction, color: currentColor)
        }
        
        actionSheet.addAction(redSelectedAction)
        actionSheet.addAction(greenSelectedAction)
        actionSheet.addAction(yellowSelectedAction)
        actionSheet.addAction(cancelAction)
        
        actionSheet.popoverPresentationController?.sourceView = viewController.view
        
        let screenSize = UIScreen.main.bounds
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            if isLandscape {
                actionSheet.popoverPresentationController?.sourceRect = CGRect(x: screenSize.size.width/2-240, y: screenSize.size.height, width: 0, height: 0)
            } else {
                actionSheet.popoverPresentationController?.sourceRect = CGRect(x: screenSize.size.width/2-68, y: screenSize.size.height, width: 0, height: 0)
            }
        }
        else if UIDevice.current.userInterfaceIdiom == .phone {
            actionSheet.popoverPresentationController?.sourceRect = CGRect(x: screenSize.size.width/2, y: screenSize.size.height, width: 0, height: 0)
        }
        
        
        viewController.present(actionSheet, animated: true, completion: nil)
    }
    
    static func setSelectShotClockColor(action: UIAlertAction, color: UIColor) -> UIAlertAction {
            
        action.setValue(UIImage(named: "checkmark.png")?.scaleImage(scaleSize: 0.4), forKey: "image")
        action.setValue(color, forKey: "imageTintColor")
        action.setValue(color, forKey: "titleTextColor")
        
        return action
    }
}
