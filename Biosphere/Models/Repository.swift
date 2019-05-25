class Repository {
  // Shared
  public var id: String = ""
  public var label: String = ""
  
  // Remote
  public var url: String = ""
  public var subdirectory: String = ""
  
  // Local path
  public var path: String = ""
  
  public var asJson: Dictionary<String, String> {
    return ["id": id,
            "label": label,
            "url": url,
            "subdirectory": subdirectory,
            "path": path]
  }
}
