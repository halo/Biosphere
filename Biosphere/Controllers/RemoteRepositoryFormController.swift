import Cocoa

class RemoteRepositoryFormController: NSWindowController, NSWindowDelegate, FocussingNSTextFieldDelegate {
  
  @IBOutlet weak var urlTextField: FocussingNSTextField!
  @IBOutlet weak var subdirectoryTextField: FocussingNSTextField!
  @IBOutlet var urlHelpPopover: NSPopover!
  @IBOutlet var urlHelpPopoverViewController: NSViewController!
  @IBOutlet var subdirectoryHelpPopover: NSPopover!
  @IBOutlet var subdirectoryHelpPopoverViewController: NSViewController!

  func windowDidChangeOcclusionState(_ notification: Notification) {
    if (window!.occlusionState.contains(.visible)) {
      // Without the following line, the subdirectory popover is not shown the first time :/
      let _ = subdirectoryTextField.becomeFirstResponder()
      // Without the following lines, the url popover is not shown initially
      let _ = urlTextField.becomeFirstResponder()
      
      DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        // Show the popup after 2 seconds to not overload people's brains
        self.textFieldDidBecomeFirstResponder(self.urlTextField)
      }
    }
  }
 
  @IBAction func urlHelp(sender: NSButton) {
  }
  
  @IBAction func cancel(sender: NSButton) {
    Log.debug("Cancelling the sheet")
    window?.sheetParent!.endSheet(window!)
  }
  
  
  func textFieldDidBecomeFirstResponder(_ textField: FocussingNSTextField) {
    switch textField {
    case urlTextField:
      urlHelpPopover.show(relativeTo: NSRect(), of: textField, preferredEdge: NSRectEdge.maxX)
    case subdirectoryTextField:
      subdirectoryHelpPopover.show(relativeTo: NSRect(), of: textField, preferredEdge: NSRectEdge.maxX)
    default:
      Swift.print("unkonwn textfield become")
    }
  }
  
  func textFieldDidResignFirstResponder(_ textField: FocussingNSTextField) {
    switch textField {
    case urlTextField:
      urlHelpPopover.close()
    case subdirectoryTextField:
      subdirectoryHelpPopover.close()
    default:
      Swift.print("unkonwn textfield resign")
    }
  }
}
