import Cocoa

class CreateFirstRepositoryController: NSViewController {
  
  @IBOutlet weak var urlTextField: NSTextField!
  @IBOutlet weak var subdirectoryTextfield: NSTextField!
  
  public var satisfied: Bool {
    if Config.instance.repositories.isEmpty {
      Log.debug("There are no known repositories.")
      return false
    } else {
      Log.debug("I already know about some repository.")
      return true
    }
  }

  @IBAction func createRepository(_ sender: Any) {
  }
  
}
