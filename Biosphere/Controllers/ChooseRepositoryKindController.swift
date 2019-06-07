import Cocoa

class ChooseRepositoryKindController: NSWindowController {
  
  public func show(onWindow: NSWindow) {
    guard let myWindow = self.window else {
      Log.error("Why don't I have a window?")
      return
    }
    
    onWindow.beginSheet(myWindow, completionHandler: { response in
      Log.debug("repository kind response: \(response)")
    })
  }
  
  @IBAction func cancel(_ sender: NSButton) {
    hide()
  }
  
  public func hide() {
    window?.sheetParent!.endSheet(window!)
  }
}
