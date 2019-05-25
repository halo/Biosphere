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
    guard let rawRepositoriesDictionary = dictionary["repositories"] as? [String: Any] else { return [] }
    var repositories: [Repository] = []
      
    for (id, rawAttributes) in rawRepositoriesDictionary {
      guard let attributes = rawAttributes as? Dictionary<String, String> else {
        break
      }

      let repository = Repository()
      repository.id = id
      repository.label = attributes["label"] ?? "unknown label"
      repository.url = attributes["url"] ?? ""
      repository.subdirectory = attributes["subdirectory"] ?? ""
      repository.path = attributes["path"] ?? ""
      repositories.append(repository)
    }
    return repositories
  }


}
