import Cocoa

class AutomationController: NSViewController {
  
  public var isSatisfied: Bool {
    return true
  }

  @IBAction func goToPrivacySettings(sender: NSButton) {
    if NSWorkspace.shared.open(Paths.automationPrivacySettingsUrl) {
      Log.debug("Go to privacy -> automation Link was clicked")
    }
  }
  
}
