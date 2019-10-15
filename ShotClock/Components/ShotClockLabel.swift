//
//  ShotClockLabel.swift
//  ShotClock
//
//  Created by Nobuhiro Harada on 2019/10/07.
//  Copyright © 2019 Nobuhiro Harada. All rights reserved.
//

import UIKit

class ShotClockLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.text = "24"
        self.textAlignment = .center
        self.textColor = .yellow
        self.isUserInteractionEnabled = true

        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            initPhoneAttr()
        case .pad:
            checkOrientation4Pad()
        default:
            initPhoneAttr()
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
}
