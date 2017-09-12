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


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var preferencesWindowController: MASPreferencesWindowController!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application

        UserDefaults.standard.register(defaults: ["NSApplicationCrashOnExceptions": true])
        Fabric.with([Crashlytics.self])

        PreferenceManager.setUp()
        UpdateManager.setUp()
        AutostartManager.setUp()

        if preferencesWindowController == nil {
            let vcs = [GeneralViewController(), ConfigureViewController(), nil, AboutViewController()]
            preferencesWindowController = MASPreferencesWindowController(viewControllers: vcs, title:"")
        }
        preferencesWindowController.window?.center()
        preferencesWindowController.showWindow(nil)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


    func applicationDidBecomeActive(_ notification: Notification) {
        preferencesWindowController.showWindow(self)
    }
}

