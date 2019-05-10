import Foundation

class BioHelper: NSObject {

  static var version: Version = {
    if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
      return Version(version)
    }
    return Version("?.?.?")
  }()

  // MARK Private Properties

  lazy var listener: NSXPCListener = {
    let listener = NSXPCListener(machServiceName:"io.halo.github.biohelper")
    listener.delegate = self
    return listener
  }()

  var shouldQuit = false

  // MARK Instance Methods

  func listen(){
    Log.debug("Helper \(BioHelper.version.formatted) says hello")
    listener.resume() // Tell the XPC listener to start processing requests.

    while !shouldQuit {
      RunLoop.current.run(until: Date.init(timeIntervalSinceNow: 1))
    }
    Log.debug("Helper shutting down now.")
  }

}

// MARK: - HelperProtocol
extension BioHelper: HelperProtocol {

  func version(reply: (String) -> Void) {
    reply(BioHelper.version.formatted)
  }

  func installChef(reply: (Bool) -> Void) {
    
    
    reply(true) // <- Famous last words
  }

  func uninstallHelper(reply: (Bool) -> Void) {
    UninstallHelper.perform()
    reply(true)
  }
}

// MARK: - NSXPCListenerDelegate
extension BioHelper: NSXPCListenerDelegate {

  func listener(_ listener:NSXPCListener, shouldAcceptNewConnection newConnection: NSXPCConnection) -> Bool {
    newConnection.exportedInterface = NSXPCInterface(with: HelperProtocol.self)
    newConnection.exportedObject = self;
    newConnection.invalidationHandler = (() -> Void)? {
      Log.debug("Helper lost connection, queuing up for shutdown...")
      self.shouldQuit = true
    }
    newConnection.resume()
    return true
  }

}
