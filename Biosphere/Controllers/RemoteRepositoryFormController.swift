import Cocoa

class RemoteRepositoryFormController: NSWindowController {
  
  @IBOutlet weak var nameTextField: FocussingNSTextField!
  @IBOutlet weak var urlTextField: FocussingNSTextField!
  @IBOutlet weak var subdirectoryTextField: FocussingNSTextField!
  
  @IBOutlet var nameHelpPopover: NSPopover!
  @IBOutlet var urlHelpPopover: NSPopover!
  @IBOutlet var subdirectoryHelpPopover: NSPopover!

   @IBAction func cancel(sender: NSButton) {
    Log.debug("Cancelling the sheet")
    window?.sheetParent!.endSheet(window!)
  }
  
  @IBAction func save(sender: NSButton) {
    Log.debug("Saving the sheet")
    ConfigWriter.addRemoteRepository(label: nameTextField.stringValue,
                                     url: urlTextField.stringValue,
                                     subdirectory: subdirectoryTextField.stringValue)
    DispatchQueue.main.async {
      NotificationCenter.default.post(name:.dependenciesChanged, object: nil, userInfo: nil)
    }
    
    window?.sheetParent!.endSheet(window!)
  }
  
 
}

extension RemoteRepositoryFormController: NSWindowDelegate {
  func windowDidChangeOcclusionState(_ notification: Notification) {
    if (window!.occlusionState.contains(.visible)) {
      // Without the following lines, the popover is not shown the first time :/
      let _ = urlTextField.becomeFirstResponder()
      let _ = subdirectoryTextField.becomeFirstResponder()
      // Without the following lines, the url popover is not shown initially
      let _ = nameTextField.becomeFirstResponder()
      
      DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
        // If any other popup is showing, don't do anything
        if self.urlHelpPopover.isShown { return }
        if self.subdirectoryHelpPopover.isShown { return }
        // Show the popup after a few seconds to not overload people's brains
        self.textFieldDidBecomeFirstResponder(self.nameTextField)
      }
    }
  }
  

}


extension RemoteRepositoryFormController: FocussingNSTextFieldDelegate {
  func textFieldDidBecomeFirstResponder(_ textField: FocussingNSTextField) {
    switch textField {
    case nameTextField:
      nameHelpPopover.show(relativeTo: NSRect(), of: textField, preferredEdge: NSRectEdge.maxX)
    case urlTextField:
      urlHelpPopover.show(relativeTo: NSRect(), of: textField, preferredEdge: NSRectEdge.maxX)
    case subdirectoryTextField:
      subdirectoryHelpPopover.show(relativeTo: NSRect(), of: textField, preferredEdge: NSRectEdge.maxX)
    default:
      Log.error("unkonwn textfield become")
    }
  }
  
  func textFieldDidResignFirstResponder(_ textField: FocussingNSTextField) {
    switch textField {
    case nameTextField:
      nameHelpPopover.close()
    case urlTextField:
      urlHelpPopover.close()
    case subdirectoryTextField:
      subdirectoryHelpPopover.close()
    default:
      Log.error("unkonwn textfield resign")
    }
  }
}

