import Foundation

class Repository {
  // Shared
  public var id: String = ""
  public var label: String = ""
  public var cookbook: String = ""
  public var privileged: String = ""

  // Remote
  public var url: String = ""
  public var subdirectory: String = ""
  
  // Local
  public var path: String = ""
  
  public var isRemote: Bool {
    return path == ""
  }
  
  public var isLocal: Bool {
    return !isRemote
  }
  
  public var isPrivileged: Bool {
    return privileged != ""
  }

  public var cachePath: String {
    if isLocal { return path }
    
    return Paths.chefCookbooksDirectory.appendPath(cacheKey)
  }
  
  public var cookbooksPath: String {
    if isLocal { return path }
    
    return cachePath.appendPath(subdirectory)
  }

  public var runList: String {
    if (cookbook == "") {
      return "recipe[default]"
    }
    
   return "recipe[\(cookbook)]"
  }

  public var asJson: Dictionary<String, String> {
    return ["id": id,
            "label": label,
            "url": url,
            "subdirectory": subdirectory,
            "path": path,
            "cookbook": cookbook,
            "privileged": privileged]
  }

  
  private var cacheKey: String {
    let key = "\(url)-\(path)"
    // Deleting and adding a repository with the same URL will have a new ID and thus a new local clone
    // So you could start afresh if a `git pull` does not succeeds (e.g. due to a `push --force`)
    return "\(id)-" + Data(key.utf8).base64EncodedString()
  }
  
}
