//
//  GeneralViewController.swift
//  Funkey
//
//  Created by Jie Zhang on 2/8/17.
//  Copyright © 2017 Jie Zhang. All rights reserved.
//

import Cocoa
import MASPreferences
import ReactiveCocoa
import ReactiveSwift
import Sparkle

class GeneralViewController: NSViewController {

    @IBOutlet weak var autoStartAtLoginButton: NSButton!
    @IBOutlet weak var autoCheckButton: NSButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        autoStartAtLoginButton.reactive.state <~ AutostartManager.autostartAtLogin.map{ $0 ? 1 : 0 }
        autoCheckButton.reactive.state <~ UpdateManager.autoCheck.map{ $0 ? 1 : 0 }
    }
    
    @IBAction func autoStartChanged(_ sender: NSButton) {
        AutostartManager.autostartAtLogin.swap(sender.state == .on ? true : false)
    }

    @IBAction func autoCheckChanged(_ sender: NSButton) {
        UpdateManager.autoCheck.swap(sender.state == .on ? true : false)
    }

    @IBAction func checkNowClicked(_ sender: NSButton) {
        SUUpdater.shared().checkForUpdates(sender)
    }

    @IBAction func quitAppClicked(_ sender: NSButton) {
        NSApp.terminate(sender)
    }
}

extension GeneralViewController: MASPreferencesViewController {
    var viewIdentifier: String {
        return "general"
    }

    var toolbarItemImage: NSImage? {
        get {
            return NSImage(named: NSImage.Name.preferencesGeneral)
        }
    }
    var toolbarItemLabel: String? {
        return "General"
    }
}
