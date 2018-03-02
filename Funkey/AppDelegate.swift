//
//  AppDelegate.swift
//  Funkey
//
//  Created by Jie Zhang on 2/8/17.
//  Copyright © 2017 Jie Zhang. All rights reserved.
//

import Cocoa
import MASPreferences
import Fabric
import Crashlytics

private let showPreferenceWindow = "showPreferenceWindowKey"

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var preferencesWindowController: MASPreferencesWindowController!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application

        UserDefaults.standard.register(defaults: ["NSApplicationCrashOnExceptions": true,
                                                  showPreferenceWindow: true])
        Fabric.with([Crashlytics.self])

        PreferenceManager.setUp()
        UpdateManager.setUp()
        AutostartManager.setUp()

        if preferencesWindowController == nil {
            let vcs = [GeneralViewController(), ConfigureViewController(), nil, AboutViewController()]
            preferencesWindowController = MASPreferencesWindowController(viewControllers: vcs, title:"")
        }
        preferencesWindowController.window?.center()

        // Register hotkey
        _ = HotKeyManager.shared

        let shouldShowPrefs = UserDefaults.standard.bool(forKey: showPreferenceWindow)
        if shouldShowPrefs  {
            preferencesWindowController.showWindow(nil)
            NSApp.activate(ignoringOtherApps: true)
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
        UserDefaults.standard.set(self.preferencesWindowController.window!.isVisible, forKey: showPreferenceWindow)
    }

    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        preferencesWindowController.showWindow(self)
        return true
    }
}

