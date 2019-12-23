//
//  ShotClockView.swift
//  ShotClock
//
//  Created by Nobuhiro Harada on 2019/10/07.
//  Copyright © 2019 Nobuhiro Harada. All rights reserved.
//
import UIKit

final class ShotClockView: UIView {
    
    var shotClockTimer: Timer!
    var shotSeconds: Int = 24
    var shotClockStatus: ShotClockStatus = .START
    enum ShotClockStatus: String {
        case START
        case STOP
        case RESUME
    }
    
    var shotClockLabel: ShotClockLabel
    var controlButton: ControlButton
    var resetButton: ResetButton
    var sec24Button: ShotClockSmallButton
    var sec14Button: ShotClockSmallButton
    
    var buzzerButton: BuzzerButton
    
    var settingButton: SettingButton
    
    override init(frame: CGRect) {
        shotClockLabel = ShotClockLabel()
        
        controlButton = ControlButton()
        
        resetButton = ResetButton()
        resetButton.isEnabled = false
        
        sec24Button = ShotClockSmallButton()
        sec24Button.setTitle("24", for: .normal)
        
        sec14Button = ShotClockSmallButton()
        sec14Button.setTitle("14", for: .normal)
        
        buzzerButton = BuzzerButton()
        
        settingButton = SettingButton()
        
        super.init(frame: frame)
        
        self.addSubview(shotClockLabel)
        self.addSubview(controlButton)
        self.addSubview(resetButton)
        self.addSubview(sec24Button)
        self.addSubview(sec14Button)
        self.addSubview(buzzerButton)
        self.addSubview(settingButton)
        
        checkShotClockStatus()
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
    
    func portrait(frame: CGRect) {
        
        self.frame = frame
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            checkOrientation4Pad()
        }
        
        shotClockLabel.center = CGPoint(x: frame.width*(1/2), y: frame.height*(1/2))
        
        let btnPosY = frame.height*(10/12)
        
        controlButton.center = CGPoint(x: frame.width*(2/16), y: btnPosY)
        
        resetButton.center = CGPoint(x: frame.width*(5/16), y: btnPosY)
                
        sec24Button.center = CGPoint(x: frame.width*(8/16), y: btnPosY)
        sec14Button.center = CGPoint(x: frame.width*(11/16), y: btnPosY)
        
        buzzerButton.center = CGPoint(x: frame.width*(14/16), y: btnPosY)
        
        settingButton.center = CGPoint(x: frame.width*(11/12), y: frame.height*(1/12))
    }
    
    func landscape(frame: CGRect) {
        
        self.frame = frame
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            checkOrientation4Pad()
        }
        
        shotClockLabel.center = CGPoint(x: frame.width*(1/2), y: frame.height*(1/2))
        
        let shotClockButtonY = frame.height*(11/12)

        controlButton.center = CGPoint(x: frame.width*(1/6), y: shotClockButtonY)

        resetButton.center = CGPoint(x: frame.width*(2/6), y: shotClockButtonY)

        sec24Button.center = CGPoint(x: frame.width*(3/6), y: shotClockButtonY)
        sec14Button.center = CGPoint(x: frame.width*(4/6), y: shotClockButtonY)
        
        buzzerButton.center = CGPoint(x: frame.width*(5/6), y: shotClockButtonY)
        
        settingButton.center = CGPoint(x: frame.width*(11/12), y: frame.height*(1/12))
    }
    
    func initPadAttrPortrait() {
        shotClockLabel.initPadAttrPortrait()
    }
    
    func initPadAttrLandscape() {
        shotClockLabel.initPadAttrLandscape()
    }
    
    func checkShotClockStatus() {
        if userdefaults.bool(forKey: IS_SHOTCLOCK_24) {
            sec24Button.alpha = 1.0
            sec14Button.alpha = 0.3
        } else {
            sec24Button.alpha = 0.3
            sec14Button.alpha = 1.0
        }
    }
    
    func reset() {
        if shotClockTimer != nil {
            shotClockTimer.invalidate()
        }

        shotSeconds = 24
        shotClockLabel.text = "24"
        controlButton.setImage(UIImage(named: "start.png"), for: .normal)
        resetButton.isEnabled = false
        shotClockStatus = .START
        sec24Button.alpha = 1.0
        sec14Button.alpha = 0.3
        userdefaults.set(true, forKey: IS_SHOTCLOCK_24)
        shotClockLabel.textColor = .yellow
        userdefaults.setShotClockColor(.yellow, forKey: SHOT_CLOCK_COLOR)
    }
    
    func getNavbarHeight() -> CGFloat {
        
        var height = 49.0
        if UIDevice.current.userInterfaceIdiom == .phone {
            
            if isLandscape {
                // iPhone 8以降は高さ44、以前は30
                if UIScreen.main.bounds.size.width > 800.0 {
                    height = 44.0
                } else {
                    height = 30.0
                }
            } else {
                height = 44.0
            }
        }
        
        return CGFloat(height)
    }
    
    func getColorCollectionViewHeight() -> CGFloat {
        if isLandscape {
            return 44.0
        } else {
            return 92.0
        }
    }
}
