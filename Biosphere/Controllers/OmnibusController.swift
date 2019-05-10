import Cocoa

class OmnibusController: NSWindowController {
  public var bundle: Bundle?
  
  public var isSatisfied: Bool {
    checkHelper()
    let fileManager = FileManager.default
    
    if fileManager.fileExists(atPath: Paths.chefExecutable) {
      Log.debug("\(Paths.chefExecutable) exists")
      return true
    } else {
      Log.debug("\(Paths.chefExecutable) not found")
      return false
    }
  }
  
  @IBOutlet weak var authorizeHelperButton: NSButton!

  
  @IBAction func checkSatisfaction(sender: NSButton) {
    Log.debug("Checking satisfaction manually...")
    if isSatisfied {
      Log.debug("I am satisfied")
    } else {
      Log.debug("I am NOT satisfied")
    }
  }
  
  @IBAction func authorize(sender: NSButton) {
    Log.debug("Elevating Helper...")
    Elevator().install()
  }
  
  @IBAction func installOmnibus(sender: NSButton) {
    let task = Process()
    task.executableURL = URL(fileURLWithPath: "/usr/bin/osascript")
    task.arguments = ["-e", "tell app \"Terminal\"",
                      "-e", "do script \"curl --location --silent  https://omnitruck.chef.io/install.sh | sudo bash\"",
                      "-e", "end tell"]
    
    let pipe = Pipe()
    task.standardOutput = pipe
    task.standardError = pipe
    
    task.terminationHandler = { (process) in
      Log.debug("osascript exitet with status: \(process.terminationStatus)")
      
      let data = pipe.fileHandleForReading.readDataToEndOfFile()
      if let output = String(data: data, encoding: String.Encoding.utf8) {
        Log.debug(output)
      }
    }
    
    do {
      Log.debug("Launching osascript to install chef: \(String(describing: task.arguments))")
      try task.run()
    } catch {
      Log.debug("Failed to execute osascript. Does the executable exist?")
    }
  }
  
  func checkHelper() {
    Intercom.helperVersion(reply: { versionOrNil in
      guard let version = versionOrNil else {
        self.authorizeHelperButton.title = "Authorize Biosphere..."
        self.authorizeHelperButton.isHidden = false
        return
      }
      
      if (version.isCompatible(with: version)) {
        self.authorizeHelperButton.isHidden = true
      } else {
        self.authorizeHelperButton.title = "Re-authorize Biosphere..."
        self.authorizeHelperButton.isHidden = false
      }
    })
  }

  /**
   * Looks up the version of the Application Bundle in Info.plist.
   *
   * - Returns: An instance of `Version`.
   */
  private lazy var version: Version = {
    assert((bundle != nil), "Forgot to pass in preference pane bundle from NSPreferencePane")
    assert((bundle!.infoDictionary != nil))
    assert(((bundle?.infoDictionary?["CFBundleShortVersionString"]) != nil), "The preference pane bundle is missing CFBundleShortVersionString")
    
    return Version(bundle!.infoDictionary!["CFBundleShortVersionString"] as! String)
  }()

  override var windowNibName: String! {
    return "InstallChef"
  }
  
  public var view: NSView {
    assert((window != nil), "I really expected to have a window. Check the nib name and the window outlet.")
    assert((window!.contentView != nil), "I really expected the window in the nib to have a contentView.")
    
    return window!.contentView!;
  }
}
