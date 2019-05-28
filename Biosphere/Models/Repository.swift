import Foundation

class Repository {
  // Shared
  public var id: String = ""
  public var label: String = ""
  public var cookbook: String {
    return "biosphere"
  }

  // Remote
  public var url: String = ""
  public var subdirectory: String = ""
  
  // Local path
  public var path: String = ""
  
  public var isRemote: Bool {
    return path == ""
  }
  
  public var isLocal: Bool {
    return !isRemote
  }
  
  public var cachePath: String {
    if isLocal { return path }
    
    return Paths.chefCookbooksDirectory.appendPath(cacheKey)
  }
  
  public var cookbooksPath: String {
    if isLocal { return path }
    
    return cachePath.appendPath(subdirectory)
  }
  
  public func clone() -> Bool {
    if isLocal {
      Log.debug("No need to clone local repository \(id) at \(path)")
      return true
    }
    
    Log.debug("Preparing git task...")
    let task = Process()
    task.executableURL = URL(fileURLWithPath: Paths.gitExecutable)

    if FileManager.default.fileExists(atPath: cachePath) {
      task.arguments = ["-C", cachePath, "pull", "origin", "master"]
    } else {
      task.arguments = ["clone", url, cachePath]
    }
    Log.debug("Arguments are \(String(describing: task.arguments))")

    let pipe = Pipe()
    task.standardOutput = pipe
    task.standardError = pipe
    
    do {
      Log.debug("Launching git")
      try task.run()
    } catch {
      Log.debug("Failed to execute git")
      return false
    }
    task.waitUntilExit()
    Log.debug("Git finished")
    
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    if let output = String(data: data, encoding: String.Encoding.utf8) {
      Log.debug(output)
    }

    return true
  }

  public var asJson: Dictionary<String, String> {
    return ["id": id,
            "label": label,
            "url": url,
            "subdirectory": subdirectory,
            "path": path]
  }

  
  private var cacheKey: String {
    let key = "\(url)-\(path)"
    // Re-adding a repository will have a new ID and thus a new local clone
    // So you can start afresh if a `git pull` does not succeeds (e.g. due to a `push --force`)
    return "\(id)-" + Data(key.utf8).base64EncodedString()
  }
  
}
