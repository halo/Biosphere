import Cocoa

extension NSWindowController {
  
  // Shorcut to top view inside connected window.
  public var view: NSView {
    assert((window != nil), "I really expected to have a window. Check the nib name and the window outlet.")
    assert((window!.contentView != nil), "I really expected the window in the nib to have a contentView.")
    
    return window!.contentView!;
  }

}
