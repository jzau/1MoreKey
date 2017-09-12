//
//  HotKey.swift
//  Funkey
//
//  Created by Jie Zhang on 3/8/17.
//  Copyright © 2017 Jie Zhang. All rights reserved.
//

import Foundation

struct SingleSideModifier: Codable {
    let flags: NSEvent.ModifierFlags
    let mKey: [MKey]
    struct MKey: Codable {
        let string: String
        enum Position: String, Codable {
            case left, right
        }
        let position: Position
    }

    init(flags: NSEvent.ModifierFlags) {
        self.flags = flags
        var result: [MKey] = []
        if (flags.rawValue & NSEvent.ModifierFlags.control.rawValue) > 0 {
            let keyString = keyCodeToCharacterMap[kVK_Control]!
            if (flags.rawValue & UInt(NX_DEVICELCTLKEYMASK)) > 0 {
                result.append(MKey(string: keyString, position: .left))
            }
            if (flags.rawValue & UInt(NX_DEVICERCTLKEYMASK)) > 0 {
                result.append(MKey(string: keyString, position: .right))
            }
        }
        if (flags.rawValue & NSEvent.ModifierFlags.option.rawValue) > 0 {
            let keyString = keyCodeToCharacterMap[kVK_Option]!
            if (flags.rawValue & UInt(NX_DEVICELALTKEYMASK)) > 0 {
                result.append(MKey(string: keyString, position: .left))
            }
            if (flags.rawValue & UInt(NX_DEVICERALTKEYMASK)) > 0 {
                result.append(MKey(string: keyString, position: .right))
            }
        }
        if (flags.rawValue & NSEvent.ModifierFlags.shift.rawValue) > 0 {
            let keyString = keyCodeToCharacterMap[kVK_Shift]!
            if (flags.rawValue & UInt(NX_DEVICELSHIFTKEYMASK)) > 0 {
                result.append(MKey(string: keyString, position: .left))
            }
            if (flags.rawValue & UInt(NX_DEVICERSHIFTKEYMASK)) > 0 {
                result.append(MKey(string: keyString, position: .right))
            }
        }
        if (flags.rawValue & NSEvent.ModifierFlags.command.rawValue) > 0 {
            let keyString = keyCodeToCharacterMap[kVK_Command]!
            if (flags.rawValue & UInt(NX_DEVICELCMDKEYMASK)) > 0 {
                result.append(MKey(string: keyString, position: .left))
            }
            if (flags.rawValue & UInt(NX_DEVICERCMDKEYMASK)) > 0 {
                result.append(MKey(string: keyString, position: .right))
            }
        }
        self.mKey = result
    }
}

struct KeyCode: Codable {
    let string: String
    let code: UInt16
}

struct DThotkey: Codable {
    let originalKeyCode: UInt16
    let originalModifierFlags: UInt
    let singleSideModifier: SingleSideModifier
    let keycode: KeyCode
    let inputText: String

    struct MKey: Codable {
        let string: String
        enum Position: String, Codable {
            case left, right
        }
        let position: Position
    }

    init(keyCode: UInt16, modifierFlags: UInt, inputText: String) {
        self.originalKeyCode = keyCode
        self.originalModifierFlags = modifierFlags
        self.keycode = KeyCodeTransfer(keyCode: keyCode, modifier: modifierFlags)
        self.singleSideModifier = SingleSideModifier(flags: NSEvent.ModifierFlags(rawValue: modifierFlags))
        self.inputText = inputText
    }

}

extension NSEvent.ModifierFlags: Codable {}
