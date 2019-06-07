import Foundation

class Repositories {
  public static func saveRemote(id: String, label: String, url: String, subdirectory: String, cookbook: String, privileged: Bool) {
    if Config.instance.repositoryExists(id: id) {
      Log.debug("Repository with ID \(id) already exists, instructing to remove...")
      ConfigWriter.removeRepository(id: id)
    }
    
    Log.debug("Instructing to add repository...")
    ConfigWriter.addRemoteRepository(id: id,
                                     label: label,
                                     url: url,
                                     subdirectory: subdirectory,
                                     cookbook: cookbook,
                                     privileged: privileged)
  }
  
  public static func sync(repository: Repository) -> CommandResult {
    return Git.sync(url: repository.url, path: repository.cachePath)
  }

}
