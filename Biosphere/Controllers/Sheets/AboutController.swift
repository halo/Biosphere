import Cocoa

class AboutController: NSWindowController {
  
  @IBOutlet var versionLabel: NSTextField!

  public func show(onWindow: NSWindow) {
    guard let myWindow = self.window else {
      Log.error("Why don't I have a window?")
      return
    }
    versionLabel.stringValue = BundleVersion.string
    
    onWindow.beginSheet(myWindow, completionHandler: { response in
      Log.debug("about response: \(response)")
    })
  }
  
  @IBAction func openWebsite(_ sender: NSButton) {
    Log.debug("Opening biosphere website...")
    
    if NSWorkspace.shared.open(Paths.biosphereWebsiteUrl) {
      Log.debug("Opened page successfully")
    }
  }
  
  @IBAction func cancel(_ sender: NSButton) {
    window?.sheetParent!.endSheet(window!)
  }
}
