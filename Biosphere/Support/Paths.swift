import Foundation

extension String {
  func appendPath(_ string: String) -> String {
    return URL(fileURLWithPath: self).appendingPathComponent(string).path
  }
}

class Paths: NSObject {

  static let chefExecutable = "/opt/bin/chef-solo"
  static let chefExecutableUrl = URL(fileURLWithPath: chefExecutable)

}
