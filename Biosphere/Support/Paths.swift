import Foundation

extension String {
  func appendPath(_ string: String) -> String {
    return URL(fileURLWithPath: self).appendingPathComponent(string).path
  }
}

class Paths: NSObject {

  static let chefExecutable = "/opt/chef/bin/chef-solo"
  static let chefExecutableUrl = URL(fileURLWithPath: chefExecutable)

  static let chefDownloadWebsite = "https://downloads.chef.io/chef#mac_os_x"
  static let chefDownloadWebsiteUrl = URL(fileURLWithPath: chefExecutable)
  
  static let automationPrivacySettings = "x-apple.systempreferences:com.apple.preference.security?Privacy_Automation"
  static let automationPrivacySettingsUrl = URL(fileURLWithPath: chefExecutable)
  
}
