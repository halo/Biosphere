import Cocoa

class OmnibusController: NSViewController {
  
  public var satisfied: Bool {
    let fileManager = FileManager.default
    
    if fileManager.fileExists(atPath: Paths.chefExecutable) {
      Log.debug("\(Paths.chefExecutable) exists")
      return true
    } else {
      Log.debug("\(Paths.chefExecutable) not found")
      return false
    }
  }
  
  @IBAction func openChefWebsite(sender: NSButton) {
    Log.debug("Chef Download Page Link was clicked")
    let url = URL(string: "https://downloads.chef.io/chef#mac_os_x")!
    if NSWorkspace.shared.open(url) {
      Log.debug("Opened page successfully")
    }
  }
  
  @IBAction func installOmnibus(sender: NSButton) {
    let task = Process()
    // Could use `AEDeterminePermissionToAutomateTarget` but it's not available on High Sierra and it's buggy in Mojave.
    // See https://www.felix-schwarz.org/blog/2018/08/new-apple-event-apis-in-macos-mojave
    task.executableURL = URL(fileURLWithPath: "/usr/bin/osascript")
    task.arguments = ["-e", "tell app \"Terminal\"",
                      "-e", "do script \"curl --location --silent  https://omnitruck.chef.io/install.sh | sudo bash\"",
                      "-e", "end tell"]
    
    let pipe = Pipe()
    task.standardOutput = pipe
    task.standardError = pipe
    
    task.terminationHandler = { (process) in
      if process.terminationStatus == 0 {
        Log.debug("osascript exited successfully")
        return
      }
      Log.debug("osascript failed with status \(process.terminationStatus)")

      let data = pipe.fileHandleForReading.readDataToEndOfFile()
      guard let output = String(data: data, encoding: String.Encoding.utf8) else {
        Log.debug("osascript had no stdout and no stderr")
        return
      }
      
      if output.contains("1743") {
        Log.debug("As of now, the user denied Automation access to Terminal for System Preferences")
        DispatchQueue.main.async {
          NotificationCenter.default.post(name:.missingAutomationPermission, object: nil, userInfo: nil)
        }
        return
      }
        
      Log.debug(output)
    }
    
    do {
      Log.debug("Launching osascript to install chef: \(String(describing: task.arguments))")
      try task.run()
    } catch {
      Log.debug("Failed to execute osascript. Does the executable exist?")
    }
  }
  
}
