import Cocoa

class MissingGitWindowController: NSWindowController {

  override var windowNibName: String! {
    return "MissingGit"
  }

  
  var view: NSView {
    return window!.contentView!;
  }
}
