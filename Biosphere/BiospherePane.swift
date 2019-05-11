import Cocoa
import PreferencePanes

class BiospherePane: NSPreferencePane {
  
  public var misingAutomationPermission: Bool = false
  
  @IBOutlet weak var container: NSView!
  
  override func mainViewDidLoad() {
    Log.debug("mainViewDidLoad...")
    NotificationCenter.default.addObserver(forName: .missingAutomationPermission, object: nil, queue: nil, using: missingAutomationPermissionNotification)
    NotificationCenter.default.addObserver(forName: .forgetAutomationPermission, object: nil, queue: nil, using: forgetAutomationPermissionNotification)
    
    update()
  }
  
  private func update() {
    let newView = recommendedView
    Log.debug("Changing from current view \(mainView)")
    Log.debug("To new view \(newView)")
    for subview in mainView.subviews {
      subview.removeFromSuperview()
    }
    mainView.addSubview(newView)
  }
  
  private var recommendedView: NSView {
    if misingAutomationPermission {
      Log.debug("Currently missing automation permission, it should be displayed...")
      return automationController.view
    }
    
    guard omnibusController.satisfied else {
      Log.debug("Omnibus is not satisfied, it should be displayed...")
      return omnibusController.view
    }
    
    Log.debug("TODO: showing Default")
    return gitController.view
  }
  
  private func missingAutomationPermissionNotification(_ _: Notification) {
    Log.debug("I believe there is no automation access.")
    misingAutomationPermission = true
    update()
  }
  
  private func forgetAutomationPermissionNotification(_ _: Notification) {
    Log.debug("Maybe the user granted automation access by now.")
    misingAutomationPermission = false
    update()
  }
  
  private lazy var gitController: GitController = {
    Log.debug("Initializing GitController...")
    return GitController()
  }()

  private lazy var omnibusController: OmnibusController = {
    Log.debug("Initializing OmnibusController...")
    return OmnibusController()
  }()
  
  private lazy var automationController: AutomationController = {
    Log.debug("Initializing AutomationController...")
    return AutomationController()
  }()
}
