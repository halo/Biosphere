import Cocoa

class RunController: NSViewController {
  
  @IBOutlet weak var repositoryDropdown: NSPopUpButton!
  
  @IBOutlet weak var newRepositoryButton: NSButton!
  @IBOutlet weak var editRepositoryButton: NSButton!
  @IBOutlet weak var removeRepositoryButton: NSButton!
  
  override func viewDidLoad() {
    NotificationCenter.default.addObserver(forName: .dependenciesChanged, object: nil, queue: nil, using: dependenciesChangedNotification)
    
    //guard let url = BundleVersion.bundle.url(forResource: "Pencil Black", withExtension: "icns") else {
    //  Log.error("where is my pencil black")
    //  return
    //}

    guard let url = BundleVersion.bundle.url(forResource: "Pencil Black", withExtension: "icns") else {
      Log.error("where is my pencil black")
      return
    }
    guard let image = NSImage(contentsOf: url) else {
      Log.error("where is my pencil black content")
      return
    }
    image.size = NSMakeSize(12, 12)
    
    editRepositoryButton.image = image
    
    if #available(macOS 10.14, *) {
      if NSAppearance.current.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua {
        guard let darkUrl = BundleVersion.bundle.url(forResource: "Pencil White", withExtension: "icns") else {
          Log.error("where is my pencil white")
          return
        }
        guard let darkImage = NSImage(contentsOf: darkUrl) else {
          Log.error("where is my pencil black content")
          return
        }
        darkImage.size = NSMakeSize(12, 12)
editRepositoryButton.image = darkImage
}
    }
    
  }
  
  private func update() {
    repositoryDropdown.removeAllItems()
    Config.instance.repositories.forEach() {
      repositoryDropdown.addItem(withTitle: $0.label)
    }
    //repositoryDropdown.menu?.addItem(NSMenuItem.separator())
    //let addRepositoryMenuItem = NSMenuItem.init(title: "Add Repository", action: #selector(self.addRepository), keyEquivalent: "")
    //addRepositoryMenuItem.target = self
    //repositoryDropdown.menu?.addItem(addRepositoryMenuItem)
  }
  
  @objc private func addRepository(_ sender: Any) {
    Log.debug("Request for adding a repository...")
  }
  
  private func dependenciesChangedNotification(_ _: Notification) {
    update()
  }

  @IBAction func runChef(_ sender: NSButton) {
    guard let repository = selectedRepository else {
      Log.debug("No repository selected in dropdown")
      return
    }
    
    Chef(repository: repository).run()
  }
  
  
  private var selectedRepository: Repository? {
    guard let selectedTitle = repositoryDropdown.selectedItem?.title else {
      Log.error("No repository selected in dropdown")
      return nil
    }
    Log.debug("Loading repository with name \(selectedTitle)")
    return Config.instance.repository(selectedTitle)
  }
  

}
