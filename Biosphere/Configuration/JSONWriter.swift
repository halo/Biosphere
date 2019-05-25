import Foundation
import os.log

class JSONWriter {

  private var path: String

  private var url: URL {
    return URL(fileURLWithPath: path)
  }

  init(filePath: String) {
    self.path = filePath
  }

  public func write(_ dictionary: [String: Any]) {
    ensureDirectory()
    do {
      let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted) as NSData
      let jsonString = NSString(data: jsonData as Data, encoding: String.Encoding.utf8.rawValue)! as String

      do {
        try jsonString.write(toFile: path, atomically: true, encoding: .utf8)
      } catch let error as NSError {
        Log.error("Could not write: \(error)")
      }

    } catch let error as NSError {
      Log.error("Could not serialize: \(error)")
    }
  }
  
  private func ensureDirectory() {
    let manager = FileManager.default
    do {
      try manager.createDirectory(atPath: Paths.configDirectory, withIntermediateDirectories: false)
      Log.debug("Created config directory \(Paths.configDirectory)")
    } catch let error as NSError {
      Log.info("Could not create config directory \(Paths.configDirectory) does it already exist? \(error.localizedDescription)")
    }
  }
}
