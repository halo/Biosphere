import Foundation

struct ConfigWriter {

  static func reset() {
    var dictionary = [String: String]()
    dictionary["version"] = BundleVersion.string
    JSONWriter(filePath: Paths.configFile).write(dictionary)
  }
  
  static func removeRepository(id: String) {
    var currentRepositories = readCurrentRepositories()
    
    Log.debug("Removing repository with ID \(id)")
    Log.debug("From existing repositories \(currentRepositories)")
    currentRepositories.removeAll(where: { $0["id"] == id })
    
    writeRepositories(currentRepositories)
  }

  static func addRemoteRepository(id: String, label: String, url: String, subdirectory: String, cookbook: String, privileged: Bool) {
    let repository = Repository()
    repository.id = id == "" ? String(Int.random(in: 1000000 ..< 2000000)) : id
    repository.label = label
    repository.url = url
    repository.subdirectory = subdirectory
    repository.cookbook = cookbook
    repository.privileged = privileged ? "yes" : ""

    var currentRepositories = readCurrentRepositories()

    Log.debug("Adding new repository \(repository.asJson)")
    Log.debug("To existing repositories \(currentRepositories)")
    currentRepositories.append(repository.asJson)
    writeRepositories(currentRepositories)
  }
  
  private static func readCurrentRepositories() -> [[String: String]] {
    let repositoriesOnFile = dictionaryWithCurrentVersion()["repositories"] as? [[String: String]]
    return repositoriesOnFile ?? []
  }
  
  private static func writeRepositories(_ repositories: [[String: String]]) {
    var dictionary = dictionaryWithCurrentVersion()
    dictionary["repositories"] = repositories
    JSONWriter(filePath: Paths.configFile).write(dictionary)
    Config.reload()
  }
  
  private static func dictionaryWithCurrentVersion() -> [String: Any] {
    var dictionary = Config.instance.dictionary
    dictionary["version"] = BundleVersion.string
    return dictionary
  }
}
