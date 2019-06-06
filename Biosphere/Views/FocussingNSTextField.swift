import AppKit

// See https://stackoverflow.com/a/36188235
protocol FocussingNSTextFieldDelegate: NSTextFieldDelegate {
  func textFieldDidBecomeFirstResponder(_ textField: FocussingNSTextField)
  func textFieldDidResignFirstResponder(_ textField: FocussingNSTextField)
}

class FocussingNSTextField: NSTextField, NSTextDelegate {
  var expectingCurrentEditor: Bool = false
  
  override func becomeFirstResponder() -> Bool {
    let becomeFirstResponder = super.becomeFirstResponder()
    if let _ = self.delegate as? FocussingNSTextFieldDelegate, becomeFirstResponder == true {
      expectingCurrentEditor = true
    }
    return becomeFirstResponder
  }
  
  override func resignFirstResponder() -> Bool {
    let resignFirstResponder = super.resignFirstResponder()
    
    guard let delegate = self.delegate as? FocussingNSTextFieldDelegate, resignFirstResponder == true else {
      return resignFirstResponder
    }
    
    if let _ = self.currentEditor(), expectingCurrentEditor {
      delegate.textFieldDidBecomeFirstResponder(self)
    }
    self.expectingCurrentEditor = false
    return resignFirstResponder
  }
  
  override func textDidEndEditing(_ notification: Notification) {
    super.textDidEndEditing(notification)
    
    guard let delegate = self.delegate as? FocussingNSTextFieldDelegate else {
      return
    }

    if self.currentEditor() == nil {
      delegate.textFieldDidResignFirstResponder(self)
    }
  }
  
}
