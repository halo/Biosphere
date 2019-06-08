import Cocoa

protocol ChooseRepositoryKindDelegate {
  func choseRepositoryKindRemote()
  func choseRepositoryKindLocal()
}

class ChooseRepositoryKindController: NSWindowController {
  
  public var delegate: ChooseRepositoryKindDelegate?
  
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
  
  @IBAction func chooseRemote(_ sender: NSButton) {
    Log.debug("Clicked on remote repository")
    guard let delegate = self.delegate else { return }
    
    delegate.choseRepositoryKindRemote()
  }

  @IBAction func chooseLocal(_ sender: NSButton) {
    Log.debug("Clicked on local repository")
    guard let delegate = self.delegate else { return }
    
    delegate.choseRepositoryKindLocal()
  }

  public func hide() {
    window?.sheetParent!.endSheet(window!)
  }
}
