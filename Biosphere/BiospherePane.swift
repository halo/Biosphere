import Cocoa
import PreferencePanes


class BiospherePane: NSPreferencePane {
  
  public var misingAutomationPermission: Bool = false
  
  @IBOutlet weak var container: NSView!

  override func mainViewDidLoad() {
    Log.debug("mainViewDidLoad...")
    NotificationCenter.default.addObserver(forName: .missingAutomationPermission, object: nil, queue: nil, using: missingAutomationPermissionNotification)
    NotificationCenter.default.addObserver(forName: .forgetAutomationPermission, object: nil, queue: nil, using: forgetAutomationPermissionNotification)
    
  }
  
  override func didSelect() {
    update()
  }
  
  private func update() {
    // Remembering current container height
    let currentContainerHeight = container.frame.height
    
    // Swapping container content
    container.subviews.forEach { $0.removeFromSuperview() }
    let newView = recommendedView
    container.addSubview(newView)
    
    // No adjustments if the window is not visible yet
    guard let window = mainView.window else {
      Log.error("WHERE IS MY WINDOW?-----------------------")
      return
    }

    // How differs the new container height from the old one?
    let newContainerHeight = newView.frame.height
    let heightDiff = newContainerHeight - currentContainerHeight
    Log.debug("New container height differs by \(heightDiff) pixel")
    
    // Adjusting all relevant heights
    var newWindowFrame = window.frame
    newWindowFrame.size.height += heightDiff
    newWindowFrame.origin.y -= heightDiff // If height increases, bottom goes down
    Log.debug("Changing window from \(window.frame) to \(newWindowFrame)")
    window.setFrame(newWindowFrame, display: true, animate: true)

    var newMainViewFrame = mainView.frame
    newMainViewFrame.size.height += heightDiff
    //newMainViewFrame.origin.y += heightDiff
    Log.debug("Changing mainView from \(mainView.frame) to \(newMainViewFrame)")
    mainView.frame = newMainViewFrame

    //var newContainerViewFrame = container.frame
    //newContainerViewFrame.size.height += heightDiff
    ////newMainViewFrame.origin.y += heightDiff
    //Log.debug("Changing container from \(container.frame) to \(newContainerViewFrame)")
    //container.frame = newContainerViewFrame

    //var newScreenFrame = screen.frame
    //newScreenFrame.size.height += heightDiff
    ////newScreenFrame.origin.y += heightDiff
    //screen.frame = newScreenFrame

    

    
    //Log.debug("The optimal container height is \(optimalContainerHeight)")
    //
    //let windowWithoutCurrentContainerHeight = window.frame.height - container.frame.height
    //Log.debug("The current net window height is \(windowWithoutCurrentContainerHeight)")
//
    //let newWindowHeight = windowWithoutCurrentContainerHeight + optimalContainerHeight
    //Log.debug("The old window height is \(window.frame.height)")
    //Log.debug("The new window height is \(newWindowHeight)")
//
    //Log.debug("The old mainView height is \(mainView.frame.height)")
    //
    //
    //var newFrame = window.frame
    //newFrame.size.height = newWindowHeight // Height increases
    //newFrame.origin.y = window.frame.origin.y - newWindowHeight // Bottom goes down
    //window.setFrame(newFrame, display: true, animate: true)
    //mainView.needsLayout = true
    //Log.debug("The new mainView height is \(mainView.frame.height)")
//
    //var newMainViewFrame = mainView.frame
    //newMainViewFrame.size.height = newFrame.size.height
    //newMainViewFrame.origin.y = window.frame.origin.y + 600 // Bottom goes up
    //
    //mainView.frame = newWindowHeight
    //screen.frame = newWindowHeight

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
  
  private lazy var omnibusController: OmnibusController = {
    Log.debug("Initializing OmnibusController...")
    return OmnibusController.init(nibName: "InstallChef", bundle: bundle)
  }()

  private lazy var gitController: GitController = {
    Log.debug("Initializing GitController...")
    return GitController.init(nibName: "InstallGit", bundle: bundle)
  }()
  
  private lazy var automationController: AutomationController = {
    Log.debug("Initializing AutomationController...")
    return AutomationController.init(nibName: "AllowAutomation", bundle: bundle)
  }()
}
