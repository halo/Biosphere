import Foundation

struct ConfigWriter {

  static func reset() {
    var dictionary = [String: String]()
    dictionary["version"] = BundleVersion.string
    JSONWriter(filePath: Paths.configFile).write(dictionary)
  }

  static func addRemoteRepository(label: String, url: String, subdirectory: String) {
    let repository = Repository()
    repository.id = NSUUID().uuidString
    repository.label = label
    repository.url = url
    repository.subdirectory = subdirectory

    var dictionary = dictionaryWithCurrentVersion()
    guard var repositories = dictionary["repositories"] as? [[String: String]] else {
      Log.debug("Adding first repository \(repository.asJson)")
      dictionary["repositories"] = [repository.asJson]
      JSONWriter(filePath: Paths.configFile).write(dictionary)
      return
    }

    Log.debug("Adding new repository \(repository.asJson)")
    Log.debug("To existing repositories \(repositories)")
    repositories.append(repository.asJson)
    dictionary["repositories"] = repositories
    JSONWriter(filePath: Paths.configFile).write(dictionary)
  }
  
  private static func dictionaryWithCurrentVersion() -> [String: Any] {
    var dictionary = Config.instance.dictionary
    dictionary["version"] = BundleVersion.string
    return dictionary
  }
}
