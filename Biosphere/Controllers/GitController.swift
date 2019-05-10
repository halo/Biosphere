import Cocoa

class GitController: NSWindowController {
  public var isSatisfied: Bool {
    return false
  }
  
  @IBAction func installCommandLineTools(sender: NSButton) {
    let task = Process()
    task.executableURL = URL(fileURLWithPath: "/usr/bin/xcode-select")
    task.arguments = ["--install"]
    
    let pipe = Pipe()
    task.standardOutput = pipe
    task.standardError = pipe

    task.terminationHandler = { (process) in
      Log.debug("xcode-select exitet with status: \(process.terminationStatus)")
      
      let data = pipe.fileHandleForReading.readDataToEndOfFile()
      if let output = String(data: data, encoding: String.Encoding.utf8) {
        Log.debug(output)
      }
    }
    
    do {
      try task.run()
    } catch {
      Log.debug("Failed to execute xcode-select. Does the executable exist?")
    }
  }
  
  override var windowNibName: String! {
    return "InstallGit"
  }

  public var view: NSView {
    assert((window != nil), "I really expected to have a window. Check the nib name and the window outlet.")
    assert((window!.contentView != nil), "I really expected the window in the nib to have a contentView.")

    return window!.contentView!;
  }
}
