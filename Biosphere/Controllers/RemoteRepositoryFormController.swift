import Cocoa

class RemoteRepositoryFormController: NSWindowController {
  
  @IBOutlet var nameTextField: FocussingNSTextField!
  @IBOutlet var urlTextField: FocussingNSTextField!
  @IBOutlet var subdirectoryTextField: FocussingNSTextField!
  @IBOutlet var cookbookTextField: FocussingNSTextField!
  @IBOutlet var privilegedButton: NSButton!

  @IBOutlet var nameHelpPopover: NSPopover!
  @IBOutlet var urlHelpPopover: NSPopover!
  @IBOutlet var subdirectoryHelpPopover: NSPopover!
  @IBOutlet var cookbookHelpPopover: NSPopover!

  @IBOutlet var advancedContainer: NSView!
  @IBOutlet var saveButton: NSButton!
  
  private var repositoryID: String = ""
  
  public func clear() {
    Log.debug("Clearing form...")
    repositoryID = ""
    nameTextField.stringValue = ""
    urlTextField.stringValue = ""
    subdirectoryTextField.stringValue = ""
    cookbookTextField.stringValue = ""
    privilegedButton.state = .off
  }

  public func edit(repository: Repository, onWindow: NSWindow) {
    guard let myWindow = window else {
      Log.debug("I really thought I'd have a window.")
      return
    }

    Log.debug("Loading repository data into form...")
    repositoryID = repository.id
    nameTextField.stringValue = repository.label
    urlTextField.stringValue = repository.url
    subdirectoryTextField.stringValue = repository.subdirectory
    cookbookTextField.stringValue = repository.cookbook
    privilegedButton.state = repository.isPrivileged ? .on : .off

    
    Log.debug("Opening form sheet")
    onWindow.beginSheet(myWindow, completionHandler: { response in
      Log.debug("remote repository form sheet closed: \(response)")
    })
  }
  
  @IBAction func cancel(sender: NSButton) {
    Log.debug("Cancelling the sheet")
    window?.sheetParent!.endSheet(window!)
  }
  
  @IBAction func save(sender: NSButton) {
    Log.debug("Saving the sheet")
    Repositories.saveRemote(id: repositoryID,
                            label: nameTextField.stringValue,
                            url: urlTextField.stringValue,
                            subdirectory: subdirectoryTextField.stringValue,
                            cookbook: cookbookTextField.stringValue,
                            privileged: privilegedButton.state == .on)
    
    DispatchQueue.main.async {
      NotificationCenter.default.post(name:.dependenciesChanged, object: nil, userInfo: nil)
    }
    
    window?.sheetParent!.endSheet(window!)
  }
  
  @IBAction func toggleAdvanced(_ sender: NSButton) {
    guard var newFrame = window?.frame else {
      Log.error("I expected to have a window.")
      return
    }
    let show = sender.state == .on
    
    if (show) {
      Log.debug("Revealing advanced options...")
      newFrame.size.height += advancedContainer.frame.height

      // Without this dispatch, the triangle rotation animation glitches a little bit.
      DispatchQueue.main.async {
        self.window!.setFrame(newFrame, display: true, animate: true)
        self.advancedContainer.isHidden = !show
      }

    } else {
      Log.debug("Hiding advanced options...")
      newFrame.size.height -= advancedContainer.frame.height
      
      DispatchQueue.main.async {
        self.advancedContainer.isHidden = !show
        self.window!.setFrame(newFrame, display: true, animate: true)
      }
    }
  }
}

extension RemoteRepositoryFormController: NSWindowDelegate {
  func windowDidChangeOcclusionState(_ notification: Notification) {
    if (window!.occlusionState.contains(.visible)) {
      // Without the following lines, the popover is not shown the first time :/
      let _ = urlTextField.becomeFirstResponder()
      let _ = subdirectoryTextField.becomeFirstResponder()
      let _ = cookbookTextField.becomeFirstResponder()
      // Without the following lines, the url popover is not shown initially
      let _ = nameTextField.becomeFirstResponder()
      
      DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
        // If any other popup is showing, don't do anything
        if self.urlHelpPopover.isShown { return }
        if self.subdirectoryHelpPopover.isShown { return }
        if self.cookbookHelpPopover.isShown { return }
        // Show the popup after a few seconds to not overload people's brains
        self.textFieldDidBecomeFirstResponder(self.nameTextField)
      }
    }
  }
}

extension RemoteRepositoryFormController: NSTextFieldDelegate {
  func controlTextDidChange(_ notification: Notification) {
    if (nameTextField.stringValue == "" || urlTextField.stringValue == "") {
      Log.debug("Some mandatory fields are missing")
      saveButton.isEnabled = false
    } else {
      Log.debug("All mandatory fields are filled in")
      saveButton.isEnabled = true
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
    case cookbookTextField:
      cookbookHelpPopover.show(relativeTo: NSRect(), of: textField, preferredEdge: NSRectEdge.maxX)
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
    case cookbookTextField:
      cookbookHelpPopover.close()
    default:
      Log.error("unkonwn textfield resign")
    }
  }
}
