//
//  ShotClockSmallButton.swift
//  ShotClock
//
//  Created by Nobuhiro Harada on 2019/10/07.
//  Copyright © 2019 Nobuhiro Harada. All rights reserved.
//

import UIKit

class ShotClockSmallButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        tintColor = .white
        
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            initPhoneAttr()
        case .pad:
            initPadAttr()
        default:
            initPhoneAttr()
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initPhoneAttr() {

        bounds = CGRect(x: 0, y: 0, width: 40, height: 40)
        titleLabel?.font = UIFont(name: "DigitalDismay", size: 27)
    }
    
    func initPadAttr() {
        bounds = CGRect(x: 0, y: 0, width: 80, height: 80)
        titleLabel?.font = UIFont(name: "DigitalDismay", size: 54)
    }
}
