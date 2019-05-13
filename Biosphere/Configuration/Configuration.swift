/**
 * An immutable wrapper for querying the content of the configuration file.
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
    guard let repositoriesDictionary = dictionary["repositories"] as? [String: Any] else { return [] }
    
    //repositoriesDictionary
    Log.debug("repositoriesDictionary: \(repositoriesDictionary)")
    
    return []
  }


}
