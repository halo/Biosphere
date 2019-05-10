import Cocoa
import PreferencePanes

class BiospherePane: NSPreferencePane {  
  override func mainViewDidLoad() {
    Log.debug("mainViewDidLoad...")
    mainView = omnibusController.view
  }
  
  private lazy var installGitController: GitController = {
    return GitController()
  }()
  
  private lazy var omnibusController: OmnibusController = {
    Log.debug("Initializing OmnibusController...")
    let controller = OmnibusController()
    controller.bundle = bundle
    return controller
  }()

   
}
