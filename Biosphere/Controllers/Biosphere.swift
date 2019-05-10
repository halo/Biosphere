import Cocoa
import PreferencePanes

class Biosphere: NSPreferencePane {  
  override func mainViewDidLoad() {
    Log.debug("mainViewDidLoad...")
    mainView = omnibusController.view
  }
  
  private lazy var installGitController: GitController = {
    return GitController()
  }()
  
  private lazy var omnibusController: OmnibusController = {
    Log.debug("Initializing OmnibusController...")
    return OmnibusController()
  }()
}
