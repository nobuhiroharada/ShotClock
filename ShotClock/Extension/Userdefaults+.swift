//
//  Userdefaults+.swift
//  ShotClock
//
//  Created by Nobuhiro Harada on 2019/10/19.
//  Copyright © 2019 Nobuhiro Harada. All rights reserved.
//

import Foundation

extension UserDefaults {

    func setShotClockColor(_ value: ShotClockTextColor?, forKey key: String) {
        if let value = value {
            set(value.rawValue, forKey: key)
        } else {
            removeSuite(named: key)
        }
    }

    func getShotClockColor(forKey key: String) -> ShotClockTextColor? {
        if let string = string(forKey: key) {
            return ShotClockTextColor(rawValue: string)
        }
        return nil
    }
}
