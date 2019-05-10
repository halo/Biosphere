import Cocoa

class AutomationController: NSWindowController {

  public var isSatisfied: Bool {
    return true
  }

  @IBAction func goToPrivacySettings(sender: NSButton) {
    let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Automation")!
    if NSWorkspace.shared.open(url) {
      Log.debug("Link was clicked")
    }
    DispatchQueue.main.async {
      NotificationCenter.default.post(name:.missingAutomationPermission, object: nil, userInfo: nil)
    }
  }
  
  override var windowNibName: String! {
    return "AllowAutomation"
  }
}
