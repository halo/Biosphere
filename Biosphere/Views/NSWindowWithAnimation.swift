import Cocoa

class NSWindowWithAnimation: NSWindow {
  override func animationResizeTime(_ newFrame: NSRect) -> TimeInterval {
    return 0.3
  }
}
