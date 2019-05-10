import os.log
import Foundation

public struct Log {
  private static let log = OSLog(subsystem: Identifiers.gui.rawValue, category: "logger")
  
  public static func debug(_ message: String, callerPath: String = #file) {
    write(message, level: .debug, callerPath: callerPath)
  }
  
  public static func info(_ message: String, callerPath: String = #file) {
    write(message, level: .info, callerPath: callerPath)
  }
  
  public static func error(_ message: String, callerPath: String = #file) {
    write(message, level: .error, callerPath: callerPath)
  }
  
  private static func write(_ message: String, level: OSLogType, callerPath: String) {
    guard let filename = callerPath.components(separatedBy: "/").last else {
      return write(message, level: level)
    }
    
    guard let classname = filename.components(separatedBy: ".").first else {
      return write(message, level: level)
    }
    
    write("\(classname) - \(message)", level: level)
  }
  
  private static func write(_ message: String, level: OSLogType) {
    os_log("%{public}@", log: log, type: level, message)
  }
}
