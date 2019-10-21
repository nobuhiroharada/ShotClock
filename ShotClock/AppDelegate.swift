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
let SHOT_CLOCK_CHAR_CLOLR: String = "shot_clock_char_color"

var isLandscape: Bool {
    return UIApplication.shared.windows
        .first?
        .windowScene?
        .interfaceOrientation
        .isLandscape ?? false
}

let isIphoneX: Bool = {
    // iPhoneXはiOS11からなのでそれ以外の端末は除外します
    guard #available(iOS 11.0, *),
        UIDevice.current.userInterfaceIdiom == .phone else {
            return false
    }
    let nativeSize = UIScreen.main.nativeBounds.size
    let (w, h) = (nativeSize.width, nativeSize.height)
    let (d1, d2): (CGFloat, CGFloat) = (1125.0, 2436.0)

    return (w == d1 && h == d2) || (w == d2 && h == d1)
}()

enum ShotClockTextColor: String {
    case red, green, yellow
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private(set) lazy var mainViewController = MainViewController()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        if (userdefaults.object(forKey: BUZEER_AUTO_BEEP) == nil) {
            userdefaults.set(false, forKey: BUZEER_AUTO_BEEP)
        }
        
        if (userdefaults.string(forKey: SHOT_CLOCK_CHAR_CLOLR) == nil) {
            userdefaults.setShotClockColor(.yellow, forKey: SHOT_CLOCK_CHAR_CLOLR)
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

