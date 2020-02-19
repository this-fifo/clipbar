//
//  ClipbarViewController.swift
//  clipbar
//
//  Created by Filipe Herculano on 2020-02-18.
//  Copyright © 2020 Filipe Herculano. All rights reserved.
//

import Cocoa

class ClipbarViewController: NSViewController {
    
    let pasteboard: NSPasteboard = .general

    @IBOutlet var previousValue: NSTextField!
    @IBOutlet var currentValue: NSTextField!
    
    @IBAction func swap(_ sender: NSButton) {
        pasteboard.clearContents()
        pasteboard.setString(previousValue.stringValue, forType: .string)
    }
    
    @IBAction func quit(_ sender: NSButton) {
        NSApplication.shared.terminate(sender)
    }
    
    @IBAction func clear(_ sender: NSButton) {
        pasteboard.clearContents()
        currentValue.stringValue = ""
        previousValue.stringValue = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentValue.stringValue =
            pasteboard.pasteboardItems?.first?.string(forType: .string) ?? "No clipboard data found"
        
        NotificationCenter.default.addObserver(self, selector: #selector(onPasteboardChanged), name: .NSPasteboardDidChange, object: nil)
    }
    
    @objc
    func onPasteboardChanged(_ notification: Notification) {
        guard let pb = notification.object as? NSPasteboard else { return }
        guard let items = pb.pasteboardItems else { return }
        guard let item = items.first?.string(forType: .string) else { return }
        previousValue.stringValue = currentValue.stringValue
        currentValue.stringValue = item
    }
}

extension ClipbarViewController {
  // MARK: Storyboard instantiation
  static func freshController() -> ClipbarViewController {
    //1.
    let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
    //2.
    let identifier = NSStoryboard.SceneIdentifier("ClipbarViewController")
    //3.
    guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? ClipbarViewController else {
      fatalError("Why cant I find ClipbarViewController? - Check Main.storyboard")
    }
    return viewcontroller
  }
}
