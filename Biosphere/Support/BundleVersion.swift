import Foundation

class BundleVersion {
  public static var bundle: Bundle {
    // Cannot use `Bundle.main` because that is `System Preferences`
    return Bundle.init(identifier: BundleIdentifier.string)!
  }
    
  public static var string: String {
    
    guard let dictionary = bundle.infoDictionary else {
      Log.error("Where is my bundle's dictionary<?")
      return "?"
    }
    
    guard let version = dictionary["CFBundleShortVersionString"] as? String else {
      Log.error("Where is my bundle's dictionary's version?")
      return "?"
    }
    
    return version
  }
}
