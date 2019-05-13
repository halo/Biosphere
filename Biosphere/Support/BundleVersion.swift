import Foundation

class BundleVersion {
  public static var string: String {
    // Cannot use `Bundle.main` because that is `System Preferences`
    guard let bundle = Bundle.init(identifier: BundleIdentifier.string) else {
      Log.error("Where is my bundle?")
      return "?"
    }
    
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
