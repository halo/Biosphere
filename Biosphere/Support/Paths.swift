import Foundation

extension String {
  func appendPath(_ string: String) -> String {
    return URL(fileURLWithPath: self).appendingPathComponent(string).path
  }
}

class Paths: NSObject {

  static let automationPrivacySettings = "x-apple.systempreferences:com.apple.preference.security?Privacy_Automation"
  static let automationPrivacySettingsUrl = URL(string: automationPrivacySettings)!

  static let cacheDirectory = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!.appendPath(BundleIdentifier.string)
  static let cacheDirectoryUrl = URL(fileURLWithPath: cacheDirectory)
  
  static let chefDownloadWebsite = "https://downloads.chef.io/chef#mac_os_x"
  static let chefDownloadWebsiteUrl = URL(fileURLWithPath: chefDownloadWebsite)

  static let chefExecutable = "/opt/chef/bin/chef-solo"
  static let chefExecutableUrl = URL(fileURLWithPath: chefExecutable)
  
  static let configDirectory = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true).first!.appendPath(BundleIdentifier.string)
  static let configDirectoryUrl = URL(fileURLWithPath: configDirectory)

  static let gitExecutable = "/Library/Developer/CommandLineTools/usr/bin/git"
  static let gitExecutableUrl = URL(fileURLWithPath: gitExecutable)

}
