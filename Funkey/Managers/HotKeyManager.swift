//
//  HotKeyManager.swift
//  Funkey
//
//  Created by Jie Zhang on 3/8/17.
//  Copyright © 2017 Jie Zhang. All rights reserved.
//

import Foundation

class HotKeyManager {
    static let shared = HotKeyManager()

    var dtHotkeys: [DThotkey] {
        didSet {
            if let data = try? JSONEncoder().encode(dtHotkeys) {
                UserDefaults.standard.set(data, forKey: "dthotkeys")
            }
        }
    }


    private init () {
        if let data = UserDefaults.standard.data(forKey: "dthotkeys") {
            dtHotkeys = (try? JSONDecoder().decode([DThotkey].self, from: data)) ?? []
            for hotkey in dtHotkeys {
                DDHotKeyCenter.shared().registerHotKey(withKeyCode: hotkey.originalKeyCode, modifierFlags: hotkey.originalModifierFlags, target: self, action: #selector(hotkeyPressed(event:object:)), object: hotkey.inputText)
            }
        }else {
            dtHotkeys = []
        }
    }

    func addHotKeyWith(keycode: UInt16, modifier: UInt, inputText: String) {

        if let _ = DDHotKeyCenter.shared().registerHotKey(withKeyCode: keycode, modifierFlags: modifier, target: self, action: #selector(hotkeyPressed(event:object:)), object: inputText) {
            let hk = DThotkey(keyCode: keycode, modifierFlags: modifier, inputText: inputText)
            dtHotkeys.append(hk)
        }
    }

    func removeHotKey(at index: Int) {
        if index >= dtHotkeys.count {
            return
        }

        let hotkey = dtHotkeys[index]
        DDHotKeyCenter.shared().unregisterHotKey(withKeyCode: hotkey.originalKeyCode, modifierFlags: hotkey.originalModifierFlags)
        dtHotkeys.remove(at: index)
    }

    @objc private func hotkeyPressed(event: NSEvent, object: Any) {
        guard let inputText = object as? String else {
            return
        }

        let pastebord = NSPasteboard.general
        pastebord.clearContents()
        pastebord.writeObjects([inputText as NSPasteboardWriting])

        let src = CGEventSource(stateID: CGEventSourceStateID.hidSystemState)

        let cmdd = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_Command), keyDown: true)
        let cmdu = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_Command), keyDown: false)
        let spcd = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_ANSI_V), keyDown: true)
        let spcu = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_ANSI_V), keyDown: false)

        spcd?.flags = CGEventFlags.maskCommand;
        let loc = CGEventTapLocation.cghidEventTap

        cmdd?.post(tap: loc)
        spcd?.post(tap: loc)
        spcu?.post(tap: loc)
        cmdu?.post(tap: loc)
    }
}
