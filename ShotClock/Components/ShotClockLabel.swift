//
//  ShotClockLabel.swift
//  ShotClock
//
//  Created by Nobuhiro Harada on 2019/10/07.
//  Copyright © 2019 Nobuhiro Harada. All rights reserved.
//

import UIKit

enum ShotClockTextColor: String {
    case red, green, yellow, white, systemBlue, systemIndigo, systemOrange, systemPink, systemTeal
}

final class ShotClockLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.text = "24"
        self.textAlignment = .center
        self.textColor = getCurrentShotClockTextColor()
        self.isUserInteractionEnabled = true

        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            checkOrientation4Phone()
        case .pad:
            checkOrientation4Pad()
        default:
            break
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func checkOrientation4Phone() {
        if isLandscape {
            initPhoneAttrLandscape()
        } else {
            initPhoneAttrPortrait()
        }
    }
    
    func checkOrientation4Pad() {
        
        if isLandscape {
            initPadAttrLandscape()
        } else {
            initPadAttrPortrait()
        }

    }
    
    func initPhoneAttrPortrait() {
        self.bounds = CGRect(x: 0, y: 0, width: 360, height: 280)
        self.font = UIFont(name: "DigitalDismay", size: 340)
    }
    
    func initPhoneAttrLandscape() {
        self.bounds = CGRect(x: 0, y: 0, width: 400, height: 300)
        self.font = UIFont(name: "DigitalDismay", size: 380)
    }
    
    func initPadAttrPortrait() {
        self.bounds = CGRect(x: 0, y: 0, width: 900, height: 720)
        self.font = UIFont(name: "DigitalDismay", size: 750)
    }
    
    func initPadAttrLandscape() {
        self.bounds = CGRect(x: 0, y: 0, width: 900, height: 720)
        self.font = UIFont(name: "DigitalDismay", size: 750)
    }
    
    func getCurrentShotClockTextColor() -> UIColor {
        let currentColor: ShotClockTextColor = userdefaults.getShotClockColor(forKey: SHOT_CLOCK_COLOR) ?? ShotClockTextColor.yellow
        
        switch currentColor {
        case .red:
            return UIColor.red
        case .green:
            return UIColor.green
        case .yellow:
            return UIColor.yellow
        case .white:
            return UIColor.white
        case .systemBlue:
            return UIColor.systemBlue
        case .systemIndigo:
            return UIColor.systemIndigo
        case .systemOrange:
            return UIColor.systemOrange
        case .systemPink:
            return UIColor.systemPink
        case .systemTeal:
            return UIColor.systemTeal
        }
    }

}
