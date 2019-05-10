import Foundation

extension String {
  func appendPath(_ string: String) -> String {
    return URL(fileURLWithPath: self).appendingPathComponent(string).path
  }
}

class Paths: NSObject {

  static let chefExecutable = "/opt/bin/chef-solo"
  static let chefExecutableUrl = URL(fileURLWithPath: chefExecutable)

  static let helperDirectory = "/Library/PrivilegedHelperTools"
  static let helperDirectoryURL = URL(fileURLWithPath: helperDirectory)

  static let helperExecutable = helperDirectory.appendPath(Identifiers.helper.rawValue)
  static let helperExecutableURL = URL(fileURLWithPath: helperExecutable)

  static let daemonsPlistDirectory = "/Library/LaunchDaemons"
  static let daemonsPlistDirectoryURL = URL(fileURLWithPath: daemonsPlistDirectory)

  static let helperPlistFile = daemonsPlistDirectory.appendPath(Identifiers.helper.rawValue + ".plist")
  static let helperPlistFileURL = URL(fileURLWithPath: helperPlistFile)

}
