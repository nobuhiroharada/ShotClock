//
//  ShotClockLabel.swift
//  ShotClock
//
//  Created by Nobuhiro Harada on 2019/10/07.
//  Copyright © 2019 Nobuhiro Harada. All rights reserved.
//

import UIKit

final class ShotClockLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.text = "24"
        self.textAlignment = .center
        self.textColor = getTextColor()
        self.isUserInteractionEnabled = true

        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            initPhoneAttr()
        case .pad:
            checkOrientation4Pad()
        default:
            break
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func checkOrientation4Pad() {
        
        if isLandscape {
            initPadAttrLandscape()
        } else {
            initPadAttrPortrait()
        }

    }
    
    func initPhoneAttr() {
        self.bounds = CGRect(x: 0, y: 0, width: 280, height: 200)
        self.font = UIFont(name: "DigitalDismay", size: 240)
    }
    
    func initPadAttrPortrait() {
        self.bounds = CGRect(x: 0, y: 0, width: 900, height: 720)
        self.font = UIFont(name: "DigitalDismay", size: 750)
    }
    
    func initPadAttrLandscape() {
        self.bounds = CGRect(x: 0, y: 0, width: 900, height: 720)
        self.font = UIFont(name: "DigitalDismay", size: 750)
    }
    
    func getTextColor() -> UIColor {
        let currentColor: ShotClockTextColor = userdefaults.getShotClockColor(forKey: SHOT_CLOCK_CHAR_CLOLR) ?? ShotClockTextColor.yellow
        
        switch currentColor {
        case .red:
            return UIColor.red
        case .green:
            return UIColor.green
        case .yellow:
            return UIColor.yellow
        }
    }
    
    func getTextColorString() -> String {
        let currentColor: ShotClockTextColor = userdefaults.getShotClockColor(forKey: SHOT_CLOCK_CHAR_CLOLR) ?? ShotClockTextColor.yellow
        
        switch currentColor {
        case .red:
            return "setting_red".localized
        case .green:
            return "setting_green".localized
        case .yellow:
            return "setting_yellow".localized
        }
    }
    
}
