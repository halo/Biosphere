import Cocoa

class CreateFirstRepositoryController: NSViewController {
  
  public var satisfied: Bool {
    if Config.instance.repositories.isEmpty {
      Log.debug("There are no known repositories.")
      return false
    } else {
      Log.debug("I already know about some repository.")
      return true
    }
  }

  @IBAction func newRemoteRepository(sender: NSButton) {
    Log.debug("The user wants to add a new remote repository...")
    guard let mainWindow = view.window else {
      Log.error("I really thought I'd have a window")
      return
    }
    remoteRepositoryFormController.draftNew(onWindow: mainWindow)
  }

  @IBAction func newLocalRepository(sender: NSButton) {
    Log.debug("The user wants to add a new local repository...")
    guard let mainWindow = view.window else {
      Log.error("I really thought I'd have a window")
      return
    }
    localRepositoryFormController.draftNew(onWindow: mainWindow)
  }
  
  private lazy var remoteRepositoryFormController: RemoteRepositoryFormController = {
    Log.debug("Initializing RemoteRepositoryFormController...")
    return RemoteRepositoryFormController.init(windowNibName: "RemoteRepositoryForm")
  }()

  private lazy var localRepositoryFormController: LocalRepositoryFormController = {
    Log.debug("Initializing localRepositoryFormController...")
    return LocalRepositoryFormController.init(windowNibName: "LocalRepositoryForm")
  }()

}
