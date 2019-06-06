import Foundation

class Git {
  
  public static func sync(url: String, path: String) -> CommandResult {
    if FileManager.default.fileExists(atPath: path) {
      Log.debug("The path \(path) exists, choosing to pull from origin")
      return run(arguments: ["-C", path, "pull", "origin", "master"])
    } else {
      Log.debug("The path \(path) does not exist, choosing to clone fresh repository")
      return run(arguments: ["clone", url, path])
    }
  }
  
  private static func run(arguments: [String]) -> CommandResult {
    let result = CommandResult()
    Log.debug("Preparing git task...")
    let task = Process()
    task.executableURL = URL(fileURLWithPath: Paths.gitExecutable)
    task.arguments = arguments
    
    result.command = "\(Paths.gitExecutable) \(task.arguments!.joined(separator: " "))"
    let pipe = Pipe()
    task.standardOutput = pipe
    task.standardError = pipe
    
    do {
      Log.debug("Launching git")
      try task.run()
    } catch {
      Log.debug("Failed to execute git")
      result.success = false
    }
    task.waitUntilExit()
    Log.debug("Waited until git finished")
    
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    if let output = String(data: data, encoding: String.Encoding.utf8) {
      Log.debug(output)
      result.output = output
    }
    
    if (task.terminationStatus == 0) {
      Log.debug("Git command exited normally")
      result.success = true

    } else {
      Log.debug("Git command died with status \(task.terminationStatus)")
      result.success = false
    }
    return result
  }
}
