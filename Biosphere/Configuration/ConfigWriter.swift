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
    let repositoriesOnFile = dictionary["repositories"] as? [[String: String]]
    var currentRepositories: [[String: String]] = repositoriesOnFile ?? []
    
    Log.debug("Adding new repository \(repository.asJson)")
    Log.debug("To existing repositories \(currentRepositories)")
    
    dictionary["repositories"] = currentRepositories.append(repository.asJson)
    JSONWriter(filePath: Paths.configFile).write(dictionary)
  }
  
  private static func dictionaryWithCurrentVersion() -> [String: Any] {
    var dictionary = Config.instance.dictionary
    dictionary["version"] = BundleVersion.string
    return dictionary
  }
}
