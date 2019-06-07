import Foundation

class Chef {
  
  private var repository: Repository
  
  
  init(repository: Repository) {
    self.repository = repository
  }
  
  public func run() {
    ensureCacheDirectory()
    guard writeSoloConfig() else { return }
    guard writeKnifeConfig() else { return }
    
    let task = Process()
    task.executableURL = URL(fileURLWithPath: Paths.osascriptExecutable)
    task.arguments = ["-e", "tell app \"Terminal\"",
                      "-e", "activate",
                      "-e", "do script \"\(chefCommand)\"",
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
  
  private func writeSoloConfig() -> Bool {
    return JSONWriter(filePath: Paths.chefSoloConfig).write(soloConfig)
  }
  
  private func writeKnifeConfig() -> Bool {
    do {
      Log.debug("Creating knife config file at \(Paths.chefKnifeConfig)")
      try knifeConfig.write(to: Paths.chefKnifeConfigUrl, atomically: true, encoding: .utf8)
      return true
    } catch let error as NSError {
      Log.info("Could not write knife config file \(Paths.chefKnifeConfig) \(error.localizedDescription)")
      return false
    }
  }
  
  private var soloConfig: [String: Any] {
    return [
      "run_list": repository.runList,
      "biosphere": [
        "version": BundleVersion.string
      ]
    ]
  }
  
  private func ensureCacheDirectory() {
    let manager = FileManager.default
    do {
      try manager.createDirectory(atPath: Paths.cacheDirectory, withIntermediateDirectories: false)
      Log.debug("Created cache directory \(Paths.configDirectory)")
    } catch let error as NSError {
      Log.info("Could not create cache directory \(Paths.configDirectory) does it already exist? \(error.localizedDescription)")
    }
  }
  private var chefCommand: String {
    return "\(Paths.sudoExecutable) \(Paths.chefExecutable) --config '\(Paths.chefKnifeConfig)'"
  }

  // See https://docs.chef.io/config_rb_solo.html
  private var knifeConfig: String {
    return """
    checksum_path    "\(Paths.chefChecksumsDirectory)"
    cookbook_path    "\(repository.cookbooksPath)"
    file_backup_path "\(Paths.chefBackupsDirectory)"
    file_cache_path  "\(Paths.chefCacheDirectory)"
    json_attribs     "\(Paths.chefSoloConfig)"
    # log_level        :debug # :info
    # verbose_logging  true # false
    """
  }

}
