//
//  AccessibilityHelperVC.swift
//  1MoreKey
//
//  Created by Jie Zhang on 9/8/17.
//  Copyright © 2017 Jie Zhang. All rights reserved.
//

import Cocoa

class AccessibilityHelperVC: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }

    @IBAction func openSystemPanel(sender: NSButton) {
        NSWorkspace.shared.open(URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility")!)
    }
}
