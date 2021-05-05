//
//  AppDelegate.swift
//  ShotClock
//
//  Created by Nobuhiro Harada on 2019/10/07.
//  Copyright © 2019 Nobuhiro Harada. All rights reserved.
//

import UIKit

let userdefaults = UserDefaults.standard
let BUZEER_AUTO_BEEP: String = "buzzer_auto_beep"
let IS_SHOTCLOCK_24: String = "is_shotclock_24"
let SHOT_CLOCK_COLOR: String = "shot_clock_color"
let CUSTOM_SHOT_SEC: String = "custom_shot_sec"

var isLandscape: Bool {
    return UIApplication.shared.windows
        .first?
        .windowScene?
        .interfaceOrientation
        .isLandscape ?? false
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private(set) lazy var mainViewController = MainViewController()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        if (userdefaults.object(forKey: BUZEER_AUTO_BEEP) == nil) {
            userdefaults.set(false, forKey: BUZEER_AUTO_BEEP)
        }
        
        if (userdefaults.string(forKey: SHOT_CLOCK_COLOR) == nil) {
            userdefaults.setShotClockColor(.yellow, forKey: SHOT_CLOCK_COLOR)
        }

        if (userdefaults.integer(forKey: CUSTOM_SHOT_SEC) == 0) {
            userdefaults.set(14, forKey: CUSTOM_SHOT_SEC)
        }

        userdefaults.set(true, forKey: IS_SHOTCLOCK_24)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = mainViewController
        window?.makeKeyAndVisible()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

//    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, 
//        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
//    }
//
//    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
//    }


}

