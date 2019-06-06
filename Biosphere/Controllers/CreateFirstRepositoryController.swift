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
    
    guard let sheet = remoteRepositoryFormController.window else {
      Log.error("I really thought remoteRepositoryFormController has a window")
      return
    }
    remoteRepositoryFormController.clear()

    mainWindow.beginSheet(sheet, completionHandler: { response in
      Log.debug("response: \(response)")
    })
  }

  @IBAction func newLocalRepository(sender: NSButton) {
  }
  
  private lazy var remoteRepositoryFormController: RemoteRepositoryFormController = {
    Log.debug("Initializing RemoteRepositoryFormController...")
    return RemoteRepositoryFormController.init(windowNibName: "RemoteRepositoryForm")
  }()

}
