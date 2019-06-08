import Cocoa

class LocalRepositoryFormController: NSWindowController {
  
  // MARK: Outlets
  
  // Form
  @IBOutlet var nameTextField: FocussingNSTextField!
  @IBOutlet var pathTextField: FocussingNSTextField!
  @IBOutlet var cookbookTextField: FocussingNSTextField!
  @IBOutlet var privilegedButton: NSButton!
  
  // Help
  @IBOutlet var nameHelpPopover: NSPopover!
  @IBOutlet var pathHelpPopover: NSPopover!
  @IBOutlet var cookbookHelpPopover: NSPopover!
  
  // GUI
  @IBOutlet var advancedContainer: NSView!
  @IBOutlet var saveButton: NSButton!
  
  private var repositoryID: String = ""
  
  // MARK: Activation
  
  public func draftNew(onWindow: NSWindow) {
    clear()
    guard let myWindow = window else {
      Log.debug("I really thought I'd have a window.")
      return
    }
    Log.debug("Opening new form sheet")
    onWindow.beginSheet(myWindow, completionHandler: { response in
      Log.debug("new local repository form sheet closed: \(response)")
    })
  }
  
  public func edit(repository: Repository, onWindow: NSWindow) {
    guard let myWindow = window else {
      Log.debug("I really thought I'd have a window.")
      return
    }
    
    Log.debug("Loading repository data into form...")
    repositoryID = repository.id
    nameTextField.stringValue = repository.label
    pathTextField.stringValue = repository.path
    cookbookTextField.stringValue = repository.cookbook
    privilegedButton.state = repository.isPrivileged ? .on : .off
    
    Log.debug("Opening form sheet")
    onWindow.beginSheet(myWindow, completionHandler: { response in
      Log.debug("local repository form sheet closed: \(response)")
    })
  }
  
  // MARK: Actions
  
  @IBAction func cancel(sender: NSButton) {
    Log.debug("Cancelling the sheet")
    window?.sheetParent!.endSheet(window!)
  }
  
  @IBAction func save(sender: NSButton) {
    Log.debug("Saving the sheet")
    Repositories.saveLocal(id: repositoryID,
                            label: nameTextField.stringValue,
                            path: pathTextField.stringValue,
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
  
  // MARK: Private helper methods
  
  private func clear() {
    guard let _ = window else {
      Log.debug("Cannot clean form without a loaded window")
      return
    }
    Log.debug("Clearing form...")
    repositoryID = ""
    nameTextField.stringValue = ""
    pathTextField.stringValue = ""
    cookbookTextField.stringValue = ""
    privilegedButton.state = .off
  }
  
}

extension LocalRepositoryFormController: NSWindowDelegate {
  func windowDidChangeOcclusionState(_ notification: Notification) {
    if (window!.occlusionState.contains(.visible)) {
      // Without the following lines, the popover is not shown the first time :/
      let _ = pathTextField.becomeFirstResponder()
      let _ = cookbookTextField.becomeFirstResponder()
      // Without the following lines, the path popover is not shown initially
      let _ = nameTextField.becomeFirstResponder()
      
      DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
        // If any other popup is showing, don't do anything
        if self.pathHelpPopover.isShown { return }
        if self.cookbookHelpPopover.isShown { return }
        // Show the popup after a few seconds to not overload people's brains
        self.textFieldDidBecomeFirstResponder(self.nameTextField)
      }
    }
  }
}

extension LocalRepositoryFormController: NSTextFieldDelegate {
  func controlTextDidChange(_ notification: Notification) {
    if (nameTextField.stringValue == "" || pathTextField.stringValue == "") {
      Log.debug("Some mandatory fields are missing")
      saveButton.isEnabled = false
    } else {
      Log.debug("All mandatory fields are filled in")
      saveButton.isEnabled = true
    }
  }
}

extension LocalRepositoryFormController: FocussingNSTextFieldDelegate {
  func textFieldDidBecomeFirstResponder(_ textField: FocussingNSTextField) {
    switch textField {
    case nameTextField:
      nameHelpPopover.show(relativeTo: NSRect(), of: textField, preferredEdge: NSRectEdge.maxX)
    case pathTextField:
      pathHelpPopover.show(relativeTo: NSRect(), of: textField, preferredEdge: NSRectEdge.maxX)
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
    case pathTextField:
      pathHelpPopover.close()
    case cookbookTextField:
      cookbookHelpPopover.close()
    default:
      Log.error("unkonwn textfield resign")
    }
  }
}
