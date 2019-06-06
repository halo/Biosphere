import Cocoa

class RunController: NSViewController {
  
  @IBOutlet var repositoryDropdown: NSPopUpButton!
  
  @IBOutlet var newRepositoryButton: NSButton!
  @IBOutlet var editRepositoryButton: NSButton!
  @IBOutlet var removeRepositoryButton: NSButton!
  
  override func viewDidLoad() {
    NotificationCenter.default.addObserver(forName: .dependenciesChanged, object: nil, queue: nil, using: dependenciesChangedNotification)

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
  }
  
  @IBAction func addRepository(_ sender: NSButton) {
    Log.debug("Request for adding a repository...")
  }

  @IBAction func removeRepository(_ sender: NSButton) {
    Log.debug("Request for removing current repository...")
  }

  @IBAction func editRepository(_ sender: NSButton) {
    Log.debug("Request for editing current repository...")
    guard let repository = selectedRepository else {
      Log.error("You cannot edit a non-existing repository")
      return
    }
    
    if (repository.isRemote) {

      guard let window = view.window else {
        Log.error("I really thought I'd have a window")
        return
      }

      guard let sheet = remoteRepositoryFormController.window else {
        Log.error("I really thought remoteRepositoryFormController has a window")
        return
      }
      
      remoteRepositoryFormController.edit(repository)
      
      window.beginSheet(sheet, completionHandler: { response in
        Log.debug("response: \(response)")
      })
    }
  }
  
  private func dependenciesChangedNotification(_ _: Notification) {
    update()
  }

  @IBAction func runChef(_ sender: NSButton) {
    guard let repository = selectedRepository else {
      Log.debug("No repository selected in dropdown")
      return
    }
    
    guard prepareRepository(repository) else {
      Log.debug("Could not prepare repository, skipping chef run")
      return
    }
    Chef(repository: repository).run()
  }
  
  private func prepareRepository(_ repository: Repository) -> Bool{
    guard repository.isRemote else {
      Log.debug("No need to clone local repository \(repository.id) at \(repository.path)")
      return true
    }
    Log.debug("This is a remote repository, preparing sync")
    
    let result = Repositories.sync(repository: repository)
    if (result.success) {
      Log.debug("The sync was successful")
      return true
    }
    Log.debug("The sync failed")

    guard let window = view.window else {
      Log.error("I really thought I'd have a window")
      return false
    }
    
    gitFailedController.show(onWindow: window, result: result)
    
   

    return false
  }
  
  
  private var selectedRepository: Repository? {
    guard let selectedTitle = repositoryDropdown.selectedItem?.title else {
      Log.error("No repository selected in dropdown")
      return nil
    }
    Log.debug("Loading repository with name \(selectedTitle)")
    return Config.instance.repository(selectedTitle)
  }
  
  private lazy var remoteRepositoryFormController: RemoteRepositoryFormController = {
    Log.debug("Initializing RemoteRepositoryFormController...")
    return RemoteRepositoryFormController.init(windowNibName: "RemoteRepositoryForm")
  }()

  private lazy var gitFailedController: GitFailedController = {
    Log.debug("Initializing gitFailedControllerController...")
    return GitFailedController.init(windowNibName: "GitFailed")
  }()

}
