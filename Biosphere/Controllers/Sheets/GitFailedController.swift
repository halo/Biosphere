import Cocoa

class GitFailedController: NSWindowController {
  
  @IBOutlet var messageScrollView: NSScrollView!

  public func show(onWindow: NSWindow, result: CommandResult) {
    guard let window = self.window else {
      Log.error("Why don't I have a window?")
      return
    }
    
    let message = ["# Command", result.command, "", "# Output", result.output].joined(separator: "\n")

    let messageTextView: NSTextView = messageScrollView.documentView! as! NSTextView
    messageTextView.string = message
    messageTextView.scroll(.zero)
    
    onWindow.beginSheet(window, completionHandler: { response in
      Log.debug("alert response: \(response)")
    })
  }

  @IBAction func okay(_ sender: NSButton) {
    window?.sheetParent!.endSheet(window!)
  }
}
