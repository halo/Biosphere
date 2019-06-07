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

  @discardableResult public func write(_ dictionary: [String: Any]) -> Bool {
    ensureDirectory()
    do {
      let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: [.sortedKeys, .prettyPrinted]) as NSData
      let jsonString = NSString(data: jsonData as Data, encoding: String.Encoding.utf8.rawValue)! as String

      do {
        Log.debug("Writing to file: \(path)")
        try jsonString.write(toFile: path, atomically: true, encoding: .utf8)
        return true
      } catch let error as NSError {
        Log.error("Could not write: \(error)")
        return false
      }

    } catch let error as NSError {
      Log.error("Could not serialize: \(error)")
      return false
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
