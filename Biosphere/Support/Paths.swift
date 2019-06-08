import Foundation

extension String {
  func appendPath(_ string: String) -> String {
    return URL(fileURLWithPath: self).appendingPathComponent(string).path
  }
}

class Paths: NSObject {

  static let automationPrivacySettings = "x-apple.systempreferences:com.apple.preference.security?Privacy_Automation"
  static let automationPrivacySettingsUrl = URL(string: automationPrivacySettings)!

  static let biosphereWebsite = "https://github.com/halo/Biosphere"
  static let biosphereWebsiteUrl = URL(fileURLWithPath: biosphereWebsite)

  static let cacheDirectory = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!.appendPath(BundleIdentifier.string)
  static let cacheDirectoryUrl = URL(fileURLWithPath: cacheDirectory)
  
  static let chefDownloadWebsite = "https://downloads.chef.io/chef#mac_os_x"
  static let chefDownloadWebsiteUrl = URL(fileURLWithPath: chefDownloadWebsite)

  static let chefExecutable = "/opt/chef/bin/chef-solo"
  static let chefExecutableUrl = URL(fileURLWithPath: chefExecutable)
  
  static let chefKnifeConfig = cacheDirectory.appendPath("config.rb")
  static let chefKnifeConfigUrl = URL(fileURLWithPath: chefKnifeConfig)
  
  static let chefSoloConfig = cacheDirectory.appendPath("solo.json")
  static let chefSoloConfigUrl = URL(fileURLWithPath: chefSoloConfig)
  
  static let chefCacheDirectory = cacheDirectory.appendPath("cache")
  static let chefCacheDirectoryUrl = URL(fileURLWithPath: chefCacheDirectory)
  
  static let chefChecksumsDirectory = cacheDirectory.appendPath("checksums")
  static let chefChecksumsDirectoryUrl = URL(fileURLWithPath: chefChecksumsDirectory)
  
  static let chefCookbooksDirectory = cacheDirectory.appendPath("cookbooks")
  static let chefCookbooksDirectoryUrl = URL(fileURLWithPath: chefCookbooksDirectory)
  
  static let chefBackupsDirectory = cacheDirectory.appendPath("backups")
  static let chefBackupsDirectoryUrl = URL(fileURLWithPath: chefBackupsDirectory)

  static let configDirectory = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true).first!.appendPath(BundleIdentifier.string)
  static let configDirectoryUrl = URL(fileURLWithPath: configDirectory)

  static let configFile = configDirectory.appendPath("config.json")
  static let configFileUrl = URL(fileURLWithPath: configFile)

  static let curlExecutable = "/usr/bin/curl"
  static let curlExecutableUrl = URL(fileURLWithPath: curlExecutable)
  
  static let osascriptExecutable = "/usr/bin/osascript"
  static let osascriptExecutableUrl = URL(fileURLWithPath: osascriptExecutable)
  
  static let gitExecutable = "/Library/Developer/CommandLineTools/usr/bin/git"
  static let gitExecutableUrl = URL(fileURLWithPath: gitExecutable)
  
  static let sudoExecutable = "/usr/bin/sudo"
  static let sudoExecutableUrl = URL(fileURLWithPath: sudoExecutable)

}
