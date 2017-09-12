//
//  RecorderControl.swift
//  Funkey
//
//  Created by Jie Zhang on 3/8/17.
//  Copyright © 2017 Jie Zhang. All rights reserved.
//

import Cocoa

protocol RecorderControlDelegate: class {
    func shortcutRecorderDidEndRecording(recorderControl: RecorderControl)
    func shortcutRecorderDidBeginRecording(recorderControl: RecorderControl)
}

class RecorderControl: NSView {

    // Property
    var isEnabled = true
    weak var delegate: RecorderControlDelegate?

    var isRecording = false {
        didSet {
            needsDisplay = true
        }
    }

    var keycode: KeyCode? {
        didSet {
            needsDisplay = true
        }
    }
    var modifier: SingleSideModifier? {
        didSet {
            needsDisplay = true
        }
    }

    var originalEvent: NSEvent?

    override var acceptsFirstResponder: Bool {
        return isEnabled
    }

    override var canBecomeKeyView: Bool {
        return super.canBecomeKeyView && NSApp.isFullKeyboardAccessEnabled
    }

    override func becomeFirstResponder() -> Bool {
        return super.becomeFirstResponder()
    }

    override func resignFirstResponder() -> Bool {
        if isRecording {
            endRecording()
        }

        return super.resignFirstResponder()
    }

    override func viewWillMove(toWindow newWindow: NSWindow?) {
        if window != nil {
            NotificationCenter.default.removeObserver(self, name: NSWindow.didResignKeyNotification, object: window!)
            NotificationCenter.default.removeObserver(self, name: NSWindow.didBecomeKeyNotification, object: window!)
        }

        if newWindow != nil {
            NotificationCenter.default.addObserver(self, selector: #selector(endRecording), name: NSWindow.didResignKeyNotification, object: newWindow!)
            NotificationCenter.default.addObserver(self, selector: #selector(checkFirstResponder), name: NSWindow.didBecomeKeyNotification, object: newWindow!)
        }
        super.viewWillMove(toWindow: newWindow)
    }

    @objc private func checkFirstResponder() {
        if window?.firstResponder == self {
            beginRecording()
        }
    }

    override func mouseUp(with event: NSEvent) {
        beginRecording()
        super.mouseUp(with: event)
    }

    override func mouseDown(with event: NSEvent) {
        _ = becomeFirstResponder()
        super.mouseDown(with: event)
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
        drawBackground(dirtyRect)
        drawBorder(dirtyRect)
        drawLabel(dirtyRect)
    }

    private func drawBackground(_ dirtyRect: NSRect) {
        if isRecording {
            NSColor(white: 0.9, alpha: 1).setFill()
            controlShape.bounds.fill()
        }else {
            NSColor.white.setFill()
            controlShape.bounds.fill()
        }
    }

    private func drawBorder(_ dirtyRect: NSRect) {
        let border = controlShape
        border.lineWidth = 1
        NSColor(white: 0.69, alpha: 1).set()
        border.stroke()
    }

    private func drawLabel(_ dirtyRect: NSRect) {
        let p = NSMutableParagraphStyle()
        p.alignment = .center
        p.lineBreakMode = .byTruncatingTail
        p.baseWritingDirection = .leftToRight
        let attributes = [NSAttributedStringKey.paragraphStyle: p,
                          NSAttributedStringKey.font: NSFont.systemFont(ofSize: NSFont.systemFontSize),
                          NSAttributedStringKey.foregroundColor: NSColor(white: 0.3, alpha: 0.5)]
        let KEY = "⌃⇧⌥⌘ Space ⌘⌥⇧⌃"
        let attributedString = NSMutableAttributedString(string: KEY, attributes: attributes)
        for mKey in modifier?.mKey ?? []{
            var range: NSRange
            if mKey.position == .left {
                if mKey.string == "⌃" {
                    range = NSRange(location: 0, length: 1)
                }else if mKey.string == "⇧" {
                    range = NSRange(location: 1, length: 1)
                }else if mKey.string == "⌥" {
                    range = NSRange(location: 2, length: 1)
                }else if mKey.string == "⌘" {
                    range = NSRange(location: 3, length: 1)
                }else {
                    range = NSRange(location: 0, length: 0)
                }
            }else {
                if mKey.string == "⌃" {
                    range = NSRange(location: 14, length: 1)
                }else if mKey.string == "⇧" {
                    range = NSRange(location: 13, length: 1)
                }else if mKey.string == "⌥" {
                    range = NSRange(location: 12, length: 1)
                }else if mKey.string == "⌘" {
                    range = NSRange(location: 11, length: 1)
                }else {
                    range = NSRange(location: 0, length: 0)
                }
            }
            attributedString.addAttributes([NSAttributedStringKey.foregroundColor: NSColor.black], range: range)
        }
        if keycode != nil {
            if keycode!.string.lowercased() == "space" {
                let range = NSRange(location: 5, length: 5)
                attributedString.addAttributes([NSAttributedStringKey.foregroundColor: NSColor.black], range: range)
            }else {
                attributedString.append(NSAttributedString(string: " \(keycode!.string.uppercased())", attributes: attributes))
                let range = NSRange(location: 16, length: 1)
                attributedString.addAttributes([NSAttributedStringKey.foregroundColor: NSColor.black], range: range)
            }
        }
        attributedString.draw(in: NSMakeRect(10, 5, attributedString.size().width, attributedString.size().height))

    }

    override func drawFocusRingMask() {
        if isEnabled && self.window?.firstResponder == self {
            // Draw
            controlShape.fill()
        }
    }

    override var focusRingMaskBounds: NSRect {
        if isEnabled && self.window?.firstResponder == self {
            return controlShape.bounds
        }
        return NSRect.zero
    }

    private var controlShape: NSBezierPath {
        return NSBezierPath(roundedRect: bounds.insetBy(dx: 1, dy: 1), xRadius: 2.0, yRadius: 2.0)
    }

    func beginRecording() {
        if !self.isEnabled || isRecording {
            return
        }

        modifier = nil
        keycode = nil
        isRecording = true
        hotKeyMode = PushSymbolicHotKeyMode(OptionBits(kHIHotKeyModeAllDisabled))
        if delegate != nil {
            delegate?.shortcutRecorderDidBeginRecording(recorderControl: self)
        }
    }

    var hotKeyMode: Any?

    @objc func endRecording() {
        //
        isRecording = false
        if hotKeyMode != nil {
            PopSymbolicHotKeyMode(hotKeyMode as! UnsafeMutableRawPointer)
        }
        if delegate != nil {
            delegate?.shortcutRecorderDidEndRecording(recorderControl: self)
        }
    }
}

// KEY
extension RecorderControl {

    override func keyDown(with event: NSEvent) {
        if !performKeyEquivalent(with: event) {
            super.keyDown(with: event)
        }
    }

    override func flagsChanged(with event: NSEvent) {
        if isRecording {
            let m = SingleSideModifier(flags: event.modifierFlags)
            if m.mKey.count > 0 {
                modifier = m
            }else if keycode == nil {
                modifier = nil
            }
        }
        super.flagsChanged(with: event)
    }

    override func performKeyEquivalent(with event: NSEvent) -> Bool {
        if !isEnabled {
            return false
        }

        if window?.firstResponder != self {
            return false
        }

        if isRecording {
            // save...
            // delegate
            if areModifierFlagsValid(modifierFlags: event.modifierFlags, forKeyCode: event.keyCode) {
                keycode = KeyCodeTransfer(keyCode: event.keyCode, modifier: event.modifierFlags.rawValue)
                endRecording()
                originalEvent = event
                needsDisplay = true
                return true
            }
            return false
        }else if (event.keyCode == kVK_Space) {
            beginRecording()
            return true
        }

        return false
    }

}


// HELPER
extension RecorderControl {
    func areModifierFlagsValid(modifierFlags: NSEvent.ModifierFlags, forKeyCode keyCode: CUnsignedShort) -> Bool {
        // modifier is required.
        let modifier = modifierFlags.rawValue & (NSEvent.ModifierFlags.command.rawValue | NSEvent.ModifierFlags.option.rawValue | NSEvent.ModifierFlags.control.rawValue | NSEvent.ModifierFlags.shift.rawValue)
        if modifier == 0 {
            return false
        }
        return true
    }
}
