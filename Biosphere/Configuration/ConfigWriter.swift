import Foundation

struct ConfigWriter {

  static func reset() {
    var dictionary = [String: String]()
    dictionary["version"] = BundleVersion.string
    JSONWriter(filePath: Paths.configFile).write(dictionary)
  }

}
