import Cocoa
import PreferencePanes

class Biosphere: NSPreferencePane {
  @IBOutlet var container: NSView?
  
  
  override func mainViewDidLoad() {
    //let missingGitView = Bundle.main.loadNibNamed("MissingGit", owner: self, topLevelObjects: nil);
    //self.mainView = loadFromNib("MissingGit")!;
    Log.debug("what is this \(String(describing: mainView))")
    //self.mainView = missingGitView;
    //let con = MissingChefViewController.init(nibName: "MissingChef", bundle: bundle)
    self.mainView = missingGitWindowController.view
    
    //self.container?.replaceSubview((self.mainView.subviews.first)!, with: con.view)

    //Log.debug("con \(String(describing: con))")
  }
  
  private lazy var missingGitWindowController: GitController = {
    return GitController.init()
  }()
  
  
  //mainnibna
  
}
