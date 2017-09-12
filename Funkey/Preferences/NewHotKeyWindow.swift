//
//  NewHotKeyWindow.swift
//  Funkey
//
//  Created by Jie Zhang on 2/8/17.
//  Copyright © 2017 Jie Zhang. All rights reserved.
//

import Cocoa

class NewHotKeyWindow: NSWindowController {

    @IBOutlet weak var replacementTextField: NSTextField!
    @IBOutlet weak var recorderControl: RecorderControl!
    @IBOutlet weak var saveButton: NSButton!
    @IBOutlet weak var helpButton: NSButton!
    
    override func windowDidLoad() {
        super.windowDidLoad()

        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        saveButton.isEnabled = false
        recorderControl.delegate = self

        if AXIsProcessTrusted() {
            helpButton.isHidden = true
        }
    }

    @IBAction func addButtonClicked(_ sender: NSButton) {
        guard let keycode = recorderControl.keycode, let modifier = recorderControl.modifier else {
            return
        }

        HotKeyManager.shared.addHotKeyWith(keycode: keycode.code, modifier: modifier.flags.rawValue, inputText: replacementTextField.stringValue)
        window!.sheetParent?.endSheet(window!, returnCode: NSApplication.ModalResponse.OK)
    }

    @IBAction func cancelClicked(_ sender: NSButton) {
        window!.sheetParent?.endSheet(window!, returnCode: NSApplication.ModalResponse.cancel)
    }

    @IBAction func helpButtonClicked(_ sender: NSButton) {
        let viewController = AccessibilityHelperVC()
        let popover = NSPopover()
        popover.behavior = .transient
        popover.animates = true
        popover.contentViewController = viewController
        popover.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.maxX)
    }

    fileprivate func updateSaveButton() {
        if recorderControl.modifier != nil && recorderControl.keycode != nil && replacementTextField.stringValue.count > 0 {
            saveButton.isEnabled = true
        }else {
            saveButton.isEnabled = false
        }
    }

}

extension NewHotKeyWindow: NSTextFieldDelegate {

    override func controlTextDidChange(_ obj: Notification) {
        guard let _ = obj.object as? NSTextField else {
            return
        }
        updateSaveButton()
    }
}

extension NewHotKeyWindow: RecorderControlDelegate {
    func shortcutRecorderDidEndRecording(recorderControl: RecorderControl) {
        updateSaveButton()
    }

    func shortcutRecorderDidBeginRecording(recorderControl: RecorderControl) {
        saveButton.isEnabled = false
    }
}
