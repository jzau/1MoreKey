//
//  UsageViewController.swift
//  Funkey
//
//  Created by Jie Zhang on 2/8/17.
//  Copyright © 2017 Jie Zhang. All rights reserved.
//

import Cocoa
import MASPreferences

class AboutViewController: NSViewController {

    private let homepageURL = URL(string: "https://jackymelb.github.io/1MoreKey")!
    private let twitterURL = URL(string: "https://twitter.com/jackymelb")!
    private let acknolementURL = URL(string: "https://jackymelb.github.io/1MoreKey/#acknolement")!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }

    @IBAction func homepageClicked(_ sender: NSButton) {
        if sender.state == .off {
            sender.state = .on
        }
        NSWorkspace.shared.open(homepageURL)
    }

    @IBAction func twitterClicked(_ sender: NSButton) {
        if sender.state == .off {
            sender.state = .on
        }
        NSWorkspace.shared.open(twitterURL)
    }

    @IBAction func feedbackClicked(_ sender: NSButton) {
        if sender.state == .off {
            sender.state = .on
        }
        let alert = NSAlert()
        alert.messageText = "Yo!"
        alert.informativeText = "Any feedback or feature requests are welcome!"
        alert.addButton(withTitle: "Copy Email address")
        alert.addButton(withTitle: "Open Mail.app")
        alert.addButton(withTitle: "No Thanks :-!")
        let respose = alert.runModal()

        if respose == .alertSecondButtonReturn {
            // open mail
            let content = "mailto:jackymelb@gmail.com?SUBJECT=1MoreKey+Feedback"
            NSWorkspace.shared.open(URL(string: content)!)
        }else if respose == .alertFirstButtonReturn {
            let pastebord = NSPasteboard.general
            pastebord.clearContents()
            pastebord.writeObjects(["jackymelb@gmail.com" as NSPasteboardWriting])
        }
    }

    @IBAction func acknolegementClicked(_ sender: NSButton) {
        if sender.state == .off {
            sender.state = .on
        }
        NSWorkspace.shared.open(acknolementURL)
    }
}

extension AboutViewController: MASPreferencesViewController {
    override var identifier: NSUserInterfaceItemIdentifier? {
        get {
            return NSUserInterfaceItemIdentifier("about")
        } set {
            super.identifier = newValue
        }
    }
    var toolbarItemImage: NSImage? {
        get {
            return NSImage(named: NSImage.Name.info)
        }
    }
    var toolbarItemLabel: String? {
        return "About"
    }
}
