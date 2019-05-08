import Cocoa
import PreferencePanes

class Biosphere: NSPreferencePane {
  @IBOutlet var missingGitView: NSView?
  
  
  override func mainViewDidLoad() {
    //let missingGitView = Bundle.main.loadNibNamed("MissingGit", owner: self, topLevelObjects: nil);
    //self.mainView = loadFromNib("MissingGit")!;
    Log.debug("what is this \(String(describing: mainView))")
    //self.mainView = missingGitView;
    let con = MissingGitWindowController.init()
    self.mainView = con.view

    Log.debug("con \(String(describing: con))")
  }
  
  //mainnibna
  
}
