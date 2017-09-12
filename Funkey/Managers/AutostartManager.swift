//
//  AutostartManager.swift
//  1MoreKey
//
//  Created by Jie Zhang on 7/8/17.
//  Copyright © 2017 Jie Zhang. All rights reserved.
//

import Foundation
import ServiceManagement
import ReactiveSwift

class AutostartManager {
    static private let identifier = "com.nsswift.LaunchHelper"

    static let autostartAtLogin: MutableProperty<Bool> = MutableProperty(false)

    static func setUp() {
        autostartAtLogin.producer.startWithValues {
            _ = $0 ? enable() : disable()
        }
    }

    @discardableResult
    static private func enable() -> Bool {
        return SMLoginItemSetEnabled(identifier as CFString, true)
    }

    @discardableResult
    static private func disable() -> Bool {
        return SMLoginItemSetEnabled(identifier as CFString, false)
    }
}
