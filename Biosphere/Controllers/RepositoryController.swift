import Cocoa

class RepositoryController: NSWindowController {
  
  override func windowDidLoad() {
    Log.debug("NSWindowController did load")
  }
  
  override var windowNibName: NSNib.Name? {
    return "RepositoryForm"
  }
  
}
