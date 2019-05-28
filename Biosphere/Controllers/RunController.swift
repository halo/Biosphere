import Cocoa

class RunController: NSViewController {
  
  @IBOutlet weak var repositoryDropdown: NSPopUpButton!
  
  override func viewDidLoad() {
    NotificationCenter.default.addObserver(forName: .dependenciesChanged, object: nil, queue: nil, using: dependenciesChangedNotification)
  }
  
  private func update() {
    repositoryDropdown.removeAllItems()
    Config.instance.repositories.forEach() {
      repositoryDropdown.addItem(withTitle: $0.label)
    }
    repositoryDropdown.menu?.addItem(NSMenuItem.separator())
    let addRepositoryMenuItem = NSMenuItem.init(title: "Add Repository", action: #selector(self.addRepository), keyEquivalent: "")
    addRepositoryMenuItem.target = self
    repositoryDropdown.menu?.addItem(addRepositoryMenuItem)
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
