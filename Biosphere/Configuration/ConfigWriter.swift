import Foundation

struct ConfigWriter {

  static func reset() {
    var dictionary = [String: String]()
    dictionary["version"] = BundleVersion.string
    JSONWriter(filePath: Paths.configFile).write(dictionary)
  }

  static func addRemoteRepository(label: String, url: String, subdirectory: String, cookbook: String, privileged: Bool) {
    let repository = Repository()
    repository.id = String(Int.random(in: 1000000 ..< 2000000))
    repository.label = label
    repository.url = url
    repository.subdirectory = subdirectory
    repository.cookbook = cookbook
    repository.privileged = privileged ? "yes" : ""

    var dictionary = dictionaryWithCurrentVersion()
    let repositoriesOnFile = dictionary["repositories"] as? [[String: String]]
    var currentRepositories: [[String: Any]] = repositoriesOnFile ?? []
    
    Log.debug("Adding new repository \(repository.asJson)")
    Log.debug("To existing repositories \(currentRepositories)")
    currentRepositories.append(repository.asJson)
    
    dictionary["repositories"] = currentRepositories
    JSONWriter(filePath: Paths.configFile).write(dictionary)
  }
  
  private static func dictionaryWithCurrentVersion() -> [String: Any] {
    var dictionary = Config.instance.dictionary
    dictionary["version"] = BundleVersion.string
    return dictionary
  }
}
