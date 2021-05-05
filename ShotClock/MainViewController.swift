//
//  ViewController.swift
//  ShotClock
//
//  Created by Nobuhiro Harada on 2019/10/07.
//  Copyright © 2019 Nobuhiro Harada. All rights reserved.
//

import UIKit
import AVFoundation

final class MainViewController: UIViewController {

    var shotClockView: ShotClockView = ShotClockView()
    var buzzerPlayer: AVAudioPlayer?
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shotClockView.frame = self.view.frame
        self.view.addSubview(shotClockView)
         
        self.addButtonAction()
        self.registerGesturerecognizer()
        
        let buzzerURL = Bundle.main.bundleURL.appendingPathComponent("buzzer.mp3")
         
        do {
            try buzzerPlayer = AVAudioPlayer(contentsOf:buzzerURL)
             
            buzzerPlayer?.prepareToPlay()
            buzzerPlayer?.volume = 2.0
            buzzerPlayer?.delegate = self
             
        } catch {
            print(error)
        }
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if isLandscape {
            self.shotClockView.landscape(frame: self.view.frame)
        } else {
            self.shotClockView.portrait(frame: self.view.frame)
        }
        
    }

    func addButtonAction() {
        shotClockView.sec24Button.addTarget(self, action: #selector(MainViewController.sec24Button_tapped), for: .touchUpInside)
        
        shotClockView.secCustomButton.addTarget(self, action: #selector(MainViewController.sec14Button_tapped), for: .touchUpInside)
        
        shotClockView.buzzerButton.addTarget(self, action: #selector(MainViewController.buzzerButton_touchDown), for: .touchDown)
        
        shotClockView.buzzerButton.addTarget(self, action: #selector(MainViewController.buzzerButton_touchUp), for: [.touchUpInside, .touchUpOutside])
        
        shotClockView.controlButton.addTarget(self, action: #selector(MainViewController.shotClockControlButton_tapped), for: .touchUpInside)
        
        shotClockView.resetButton.addTarget(self, action: #selector(MainViewController.shotClockResetButton_tapped), for: .touchUpInside)
        
        shotClockView.settingButton.addTarget(self, action: #selector(MainViewController.settingButton_tapped), for: .touchUpInside)
    }
    
    func registerGesturerecognizer() {
        let shotClock_tap = UITapGestureRecognizer(target: self, action: #selector(MainViewController.shotClockLabel_tapped))
        shotClockView.shotClockLabel.addGestureRecognizer(shotClock_tap)
        
    }
    
    @objc func sec24Button_tapped(_ sender: UIButton) {
        shotClockView.shotSeconds = 24
        shotClockView.shotClockLabel.text = "24"
        userdefaults.set(true, forKey: IS_SHOTCLOCK_24)
        shotClockView.checkShotClockStatus()
    }

    @objc func sec14Button_tapped(_ sender: UIButton) {
        let tmpShotSeconds: Int = userdefaults.integer(forKey: CUSTOM_SHOT_SEC)
        shotClockView.shotSeconds = tmpShotSeconds
        shotClockView.shotClockLabel.text = String(tmpShotSeconds)
        userdefaults.set(false, forKey: IS_SHOTCLOCK_24)
        shotClockView.checkShotClockStatus()
    }

    @objc func shotClockControlButton_tapped(_ sender: UIButton) {
        switch shotClockView.shotClockStatus {
        case .START:
            runShotClockTimer()
            shotClockView.controlButton.setImage(UIImage(named: "stop.png"), for: .normal)
            shotClockView.shotClockStatus = .STOP
            shotClockView.resetButton.isEnabled = true

        case .STOP:
            shotClockView.shotClockTimer.invalidate()
            shotClockView.controlButton.setImage(UIImage(named: "start.png"), for: .normal)
            shotClockView.shotClockStatus = .RESUME

        case .RESUME:
            runShotClockTimer()
            shotClockView.controlButton.setImage(UIImage(named: "stop"), for: .normal)
            shotClockView.shotClockStatus = .STOP
        }
    }

    func runShotClockTimer(){
        shotClockView.shotClockTimer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(self.shotClockCount),
            userInfo: nil,
            repeats: true)
    }
    
    @objc func shotClockCount() {
        if shotClockView.shotSeconds < 1 {
            
            if userdefaults.bool(forKey: BUZEER_AUTO_BEEP) {
                buzzerPlayer?.play()
                shotClockView.buzzerButton.setImage(UIImage(named: "buzzer-down"), for: .normal)
            }
            
            shotClockView.shotClockTimer.invalidate()
            shotClockView.shotClockLabel.text = String(shotClockView.shotSeconds)
            openShotClockTimeOverDialog()
        } else {
            shotClockView.shotSeconds -= 1
            shotClockView.shotClockLabel.text = String(shotClockView.shotSeconds)
        }
    }
    
    @objc func shotClockResetButton_tapped(_ sender: UIButton) {
        switch shotClockView.shotClockStatus {
        case .START:
            return
        case .STOP:
            if userdefaults.bool(forKey: IS_SHOTCLOCK_24) {
                shotClockView.shotSeconds = 24
            } else {
                shotClockView.shotSeconds = Int(userdefaults.integer(forKey: CUSTOM_SHOT_SEC))
            }
            
            shotClockView.shotClockLabel.text = String(shotClockView.shotSeconds)
        case .RESUME:
            shotClockView.shotClockTimer.invalidate()
            
            if userdefaults.bool(forKey: IS_SHOTCLOCK_24) {
                shotClockView.shotSeconds = 24
            } else {
                shotClockView.shotSeconds = Int(userdefaults.integer(forKey: CUSTOM_SHOT_SEC))
            }
            
            shotClockView.shotClockLabel.text = String(shotClockView.shotSeconds)
            shotClockView.controlButton.setImage(UIImage(named: "start.png"), for: .normal)
            shotClockView.shotClockStatus = .START
            
            shotClockView.resetButton.isEnabled = false
        }
    }
    
    @objc func buzzerButton_touchDown(_ sender: UIButton) {
        buzzerPlayer?.play()
        shotClockView.buzzerButton.setImage(UIImage(named: "buzzer-down"), for: .normal)
    }
    
    @objc func buzzerButton_touchUp(_ sender: UIButton) {
        buzzerPlayer?.stop()
        buzzerPlayer?.currentTime = 0
        shotClockView.buzzerButton.setImage(UIImage(named: "buzzer-up"), for: .normal)
    }
    
    @objc func shotClockLabel_tapped() {
        print(shotClockView.shotClockStatus)
        if shotClockView.shotClockStatus == .STOP {
            shotClockView.shotClockTimer.invalidate()
            shotClockView.controlButton.setImage(UIImage(named: "start.png"), for: .normal)
            shotClockView.shotClockStatus = .START
        }

        AlertDialog.showShotClockEdit(title: "shotclock_title".localized, shotClockView: shotClockView, viewController: self)
    }
    
    @objc func settingButton_tapped() {
        let settingViewController = SettingViewController()
        settingViewController.shotClockView = self.shotClockView
        
        let navigationController = UINavigationController(rootViewController: settingViewController)
        let currentViewController = self.topViewController()
        currentViewController?.present(navigationController, animated: true, completion: nil)
    }
    
    func openShotClockTimeOverDialog() {
        AlertDialog.showTimeover(title: "shotclock_over".localized, viewController: self) {
            self.shotClockView.controlButton.setImage(UIImage(named: "start.png"), for: .normal)
            if userdefaults.bool(forKey: IS_SHOTCLOCK_24) {
                self.shotClockView.shotSeconds = 24
            } else {
                self.shotClockView.shotSeconds = Int(userdefaults.integer(forKey: CUSTOM_SHOT_SEC))
            }
            
            self.shotClockView.shotClockLabel.text = String(self.shotClockView.shotSeconds)
            self.shotClockView.shotClockStatus = .START
            self.shotClockView.resetButton.isEnabled = false
        }
    }
    
}

extension MainViewController: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
        shotClockView.buzzerButton.setImage(UIImage(named: "buzzer-up"), for: .normal)
        
    }
}
