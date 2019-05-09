import Cocoa

class GitController: NSWindowController {
 // @IBOutlet var installXcodeToolsButton: NSButton?
  
  public var isSatisfied: Bool {
    return false
  }

  
  @IBAction func installCommandLineTools(sender: NSButton) {
    Log.debug("do it")
    let task = Process()
    task.executableURL = URL(fileURLWithPath: "/usr/bin/xcode-select")
    task.arguments = ["--install"]
    
    let pipe = Pipe()
    task.standardOutput = pipe
    task.standardError = pipe

    task.terminationHandler = { (process) in
      Log.debug("\ndidFinish: \(!process.isRunning)")
      Log.debug("status: \(process.terminationStatus)")
      let data = pipe.fileHandleForReading.readDataToEndOfFile()
      if let string = String(data: data, encoding: String.Encoding.utf8) {
        Log.debug(string)
      }
    }
    do {
      try task.run()
    } catch {}
    /*
    let handle = pipe.fileHandleForReading
    handle.waitForDataInBackgroundAndNotify()
    
    
    // When new data is available
    var dataAvailable : NSObjectProtocol!
    dataAvailable = NotificationCenter.default.addObserver(forName: NSNotification.Name.NSFileHandleDataAvailable,
                                                           object: handle, queue: nil) { notification -> Void in
    let data = pipe.fileHandleForReading.availableData
    if data.count > 0 {
      if let str = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
        Log.debug(str as String)
      }
    }
    }
 */
  }
  
  override var windowNibName: String! {
    return "InstallGit"
  }

  var view: NSView {
    assert((window != nil), "I really expected to have a window. Check the nib name and the window outlet.")
    assert((window!.contentView != nil), "I really expected the window in the nib to have a contentView.")

    return window!.contentView!;
  }
}
