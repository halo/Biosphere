import Cocoa

class RunController: NSViewController {
  
  // MARK: Interface outlets
  
  // GUI Elements
  @IBOutlet var repositoryDropdown: NSPopUpButton!
  
  // CRUD Actions
  @IBOutlet var newRepositoryButton: NSButton!
  @IBOutlet var editRepositoryButton: NSButton!
  @IBOutlet var removeRepositoryButton: NSButton!
  
  // MARK: Initialization
  
  override func viewDidLoad() {
    NotificationCenter.default.addObserver(forName: .dependenciesChanged, object: nil, queue: nil, using: dependenciesChangedNotification)
    setupEditButton()
    update()
  }
  
  // MARK: Interface Actions
  
  @IBAction func addRepository(_ sender: NSButton) {
    Log.debug("Request for adding a repository...")

    guard let window = view.window else {
      Log.error("I really thought I'd have a window")
      return
    }

    chooseRepositoryKindController.show(onWindow: window)
  }
  
  @IBAction func removeRepository(_ sender: NSButton) {
    Log.debug("Request for removing current repository...")
    guard let repository = selectedRepository else {
      Log.error("You cannot remove a non-existing repository")
      return
    }
    ConfigWriter.removeRepository(id: repository.id)
}
  
  @IBAction func editRepository(_ sender: NSButton) {
    Log.debug("Request for editing current repository...")
    guard let repository = selectedRepository else {
      Log.error("You cannot edit a non-existing repository")
      return
    }
    editRepository(repository)
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

  // MARK: Private Repository Lifecycle
  
  private func editRepository(_ repository: Repository) {
    guard let window = view.window else {
      Log.error("I really thought I'd have a window")
      return
    }

    if (repository.isRemote) {
      remoteRepositoryFormController.edit(repository: repository, onWindow: window)
    } else {
      localRepositoryFormController.edit(repository: repository, onWindow: window)
    }
  }
  
  // MARK: Chef Run
  
  private func prepareRepository(_ repository: Repository) -> Bool{
    guard repository.isRemote else {
      Log.debug("No need to clone local repository \(repository.id) at \(repository.path)")
      return true
    }
    Log.debug("This is a remote repository, preparing sync")
    
    guard let window = view.window else {
      Log.error("I really thought I'd have a window")
      return false
    }

    gitSyncingController.show(onWindow: window)
    let result = Repositories.sync(repository: repository)
    gitSyncingController.hide()

    if (result.success) {
      Log.debug("The sync was successful")
      return true
    }
    Log.debug("The sync failed")

    gitFailedController.show(onWindow: window, result: result)
    
    return false
  }
  
  // MARK: Private GUI Lifecycle
  
  private func dependenciesChangedNotification(_ _: Notification) {
    update()
  }

  private func update() {
    repositoryDropdown.removeAllItems()
    Config.instance.repositories.forEach() {
      repositoryDropdown.addItem(withTitle: $0.label)
    }
  }

  // This whole method is only needed to make a custom icon work with light/dark mode.
  private func setupEditButton() {
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
  
  // MARK: Private instance variables
  
  private var selectedRepository: Repository? {
    guard let selectedTitle = repositoryDropdown.selectedItem?.title else {
      Log.error("No repository selected in dropdown")
      return nil
    }
    Log.debug("Loading repository with name \(selectedTitle)")
    return Config.instance.repository(label: selectedTitle)
  }
  
  private lazy var remoteRepositoryFormController: RemoteRepositoryFormController = {
    Log.debug("Initializing RemoteRepositoryFormController...")
    return RemoteRepositoryFormController.init(windowNibName: "RemoteRepositoryForm")
  }()

  private lazy var localRepositoryFormController: LocalRepositoryFormController = {
    Log.debug("Initializing localRepositoryFormController...")
    return LocalRepositoryFormController.init(windowNibName: "LocalRepositoryForm")
  }()

  private lazy var gitSyncingController: GitSyncingController = {
    Log.debug("Initializing gitSyncingController...")
    return GitSyncingController.init(windowNibName: "GitSyncing")
  }()

  private lazy var gitFailedController: GitFailedController = {
    Log.debug("Initializing gitFailedControllerController...")
    return GitFailedController.init(windowNibName: "GitFailed")
  }()

  private lazy var chooseRepositoryKindController: ChooseRepositoryKindController = {
    Log.debug("Initializing chooseRepositoryKindController...")
    let controller = ChooseRepositoryKindController.init(windowNibName: "ChooseRepositoryKind")
    controller.delegate = self
    return controller
  }()

}

extension RunController: ChooseRepositoryKindDelegate {
  func choseRepositoryKindRemote() {
    guard let window = view.window else {
      Log.error("I really thought I'd have a window")
      return
    }
    chooseRepositoryKindController.hide()
    remoteRepositoryFormController.draftNew(onWindow: window)
  }
  
  func choseRepositoryKindLocal() {
    guard let window = view.window else {
      Log.error("I really thought I'd have a window")
      return
    }
    chooseRepositoryKindController.hide()
    localRepositoryFormController.draftNew(onWindow: window)
  }
  
}
