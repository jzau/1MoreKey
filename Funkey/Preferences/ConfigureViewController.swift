//
//  ConfigureViewController.swift
//  Funkey
//
//  Created by Jie Zhang on 2/8/17.
//  Copyright © 2017 Jie Zhang. All rights reserved.
//

import Cocoa
import MASPreferences


class ConfigureViewController: NSViewController {

    @IBOutlet weak var removeButton: NSButton!
    @IBOutlet weak var tableView: NSTableView!
    var newHotKeyWindow: NewHotKeyWindow?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }

    override func viewWillAppear() {
        super.viewWillAppear()
        removeButton.isEnabled = tableView.selectedRow >= 0
    }


    @IBAction func addButtonClicked(_ sender: NSButton) {
        newHotKeyWindow = NewHotKeyWindow(windowNibName: NSNib.Name(rawValue: "NewHotKeyWindow"))
        view.window?.beginSheet(newHotKeyWindow!.window!, completionHandler: { [unowned self](returnCode) in
            self.newHotKeyWindow = nil
            if returnCode == .OK {
                self.tableView.reloadData()
            }
        })
    }
    
    @IBAction func removeButtonClicked(_ sender: NSButton) {
        let index = tableView.selectedRow
        if index == -1 {
            return
        }
        HotKeyManager.shared.removeHotKey(at: index)
        tableView.removeRows(at: IndexSet(integer: index), withAnimation: NSTableView.AnimationOptions.effectFade)
    }
}

extension ConfigureViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return HotKeyManager.shared.dtHotkeys.count
    }
}

extension ConfigureViewController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let hotkey = HotKeyManager.shared.dtHotkeys[row]

        if tableColumn?.identifier == NSUserInterfaceItemIdentifier.ShortcutColumn {
            let tableCellView = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier.ShortcutRow, owner: self)
            (tableCellView!.subviews[0] as! RecorderControl).keycode = hotkey.keycode
            (tableCellView!.subviews[0] as! RecorderControl).modifier = hotkey.singleSideModifier
            (tableCellView!.subviews[0] as! RecorderControl).isEnabled = false
            return tableCellView
        }
        let tableCellView = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier.SnippetRow, owner: self)
        (tableCellView?.subviews[0] as! NSTextField).stringValue = hotkey.inputText
        return tableCellView
    }

    func tableViewSelectionDidChange(_ notification: Notification) {
        removeButton.isEnabled = tableView.selectedRow >= 0
    }
}

extension NSUserInterfaceItemIdentifier {
    static let ShortcutColumn = NSUserInterfaceItemIdentifier("shortcut_column")
    static let SnippetRow = NSUserInterfaceItemIdentifier("snippet_row")
    static let ShortcutRow = NSUserInterfaceItemIdentifier("shortcut_row")
}

extension ConfigureViewController: MASPreferencesViewController {
    var viewIdentifier: String {
        return "configure"
    }

    var toolbarItemImage: NSImage? {
        get {
            return NSImage(named: NSImage.Name.advanced)
        }
    }
    var toolbarItemLabel: String? {
        return "Configure"
    }
}
