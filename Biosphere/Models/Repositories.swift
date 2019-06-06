import Foundation

class Repositories {
  public static func addRemote(label: String, url: String, subdirectory: String, cookbook: String, privileged: Bool) {
    ConfigWriter.addRemoteRepository(label: label,
                                     url: url,
                                     subdirectory: subdirectory,
                                     cookbook: cookbook,
                                     privileged: privileged)

  }
  
  
  public static func sync(repository: Repository) -> CommandResult {
    return Git.sync(url: repository.url, path: repository.cachePath)
  }

}
