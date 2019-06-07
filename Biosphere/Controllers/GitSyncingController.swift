import Cocoa

class GitSyncingController: NSWindowController {
  
  public func show(onWindow: NSWindow) {
    guard let myWindow = self.window else {
      Log.error("Why don't I have a window?")
      return
    }
    
    onWindow.beginSheet(myWindow, completionHandler: { response in
      Log.debug("git syncing response: \(response)")
    })
  }
  
  public func hide() {
    window?.sheetParent!.endSheet(window!)
  }
}
