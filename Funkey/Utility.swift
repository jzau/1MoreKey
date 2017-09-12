//
//  Utility.swift
//  Funkey
//
//  Created by Jie Zhang on 4/8/17.
//  Copyright © 2017 Jie Zhang. All rights reserved.
//

import Foundation

let appVersionString: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
let buildNumber: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String

func KeyCodeTransfer(keyCode: UInt16, modifier: UInt) -> KeyCode {
    if let string = keyCodeToCharacterMap[Int(keyCode)] {
        return KeyCode(string: string, code: keyCode)
    }
    let string = SRKeyCodeTransformer().transformedValue(NSNumber(value: keyCode), withImplicitModifierFlags: nil, explicitModifierFlags: NSNumber(value: modifier))
    return KeyCode(string: string!, code: keyCode)
}

let keyCodeToCharacterMap =
[kVK_Return : "↩",
kVK_Tab : "⇥",
(kVK_Space) : "Space",
(kVK_Delete) : "⌫",
(kVK_Escape) : "⎋",
(kVK_Command) : "⌘",
(kVK_Shift) : "⇧",
(kVK_CapsLock) : "⇪",
(kVK_Option) : "⌥",
(kVK_Control) : "⌃",
(kVK_RightShift) : "⇧",
(kVK_RightOption) : "⌥",
(kVK_RightControl) : "⌃",
(kVK_VolumeUp) : "🔊",
(kVK_VolumeDown) : "🔈",
(kVK_Mute) : "🔇",
//(kVK_Function) : "\u2318",
(kVK_F1) : "F1",
(kVK_F2) : "F2",
(kVK_F3) : "F3",
(kVK_F4) : "F4",
(kVK_F5) : "F5",
(kVK_F6) : "F6",
(kVK_F7) : "F7",
(kVK_F8) : "F8",
(kVK_F9) : "F9",
(kVK_F10) : "F10",
(kVK_F11) : "F11",
(kVK_F12) : "F12",
(kVK_F13) : "F13",
(kVK_F14) : "F14",
(kVK_F15) : "F15",
(kVK_F16) : "F16",
(kVK_F17) : "F17",
(kVK_F18) : "F18",
(kVK_F19) : "F19",
(kVK_F20) : "F20",
//(kVK_Help) : @"",
(kVK_ForwardDelete) : "⌦",
(kVK_Home) : "↖",
(kVK_End) : "↘",
(kVK_PageUp) : "⇞",
(kVK_PageDown) : "⇟",
(kVK_LeftArrow) : "←",
(kVK_RightArrow) : "→",
(kVK_DownArrow) : "↓",
(kVK_UpArrow) : "↑",]
