/**
 * An immutable wrapper for querying the JSON structure of the configuration file.
 */
struct Configuration {

  // MARK: Instance Properties

  /**
   * Gives access to the underlying dictionary of this configuration.
   */
  var dictionary: [String: Any]

  /**
   * Queries the version with whith the configuration was created.
   */
  lazy var version: String? = {
    return self.dictionary["version"] as? String
  }()

  // MARK: Initialization

  init(dictionary: [String: Any]) {
    self.dictionary = dictionary
  }

  // MARK: Instance Methods
  
  public var repositories: [Repository] {
    guard let rawRepositoriesDictionary = dictionary["repositories"] as? [[String: Any]] else {
      Log.error("Could not find repositories array")
      return []
    }
    var repositories: [Repository] = []
      
    for (rawAttributes) in rawRepositoriesDictionary {
      guard let attributes = rawAttributes as? [String:String] else {
        Log.error("A repository has no valid attributes \(rawAttributes)")
        break
      }

      let repository = Repository()
      repository.id = attributes["id"] ?? "unknown-id"
      repository.label = attributes["label"] ?? "unknown label"
      repository.url = attributes["url"] ?? ""
      repository.subdirectory = attributes["subdirectory"] ?? ""
      repository.path = attributes["path"] ?? ""
      repository.cookbook = attributes["cookbook"] ?? ""
      repository.privileged = attributes["privileged"] ?? ""
      repositories.append(repository)
    }
    return repositories
  }
  
  public func repository(_ label: String) -> Repository? {
    return repositories.first(where: { $0.label == label })
  }


}
