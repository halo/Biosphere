import Foundation
import ServiceManagement

class Intercom: NSObject {

  private static var xpcConnection: NSXPCConnection?

  static func reset() {
    self.xpcConnection = nil
  }

  static func helperVersion(reply: @escaping (Version?) -> Void) {
    let helper = self.connection()?.remoteObjectProxyWithErrorHandler({ _ in
      return reply(nil)
    }) as! HelperProtocol

    helper.version(reply: { rawVersion in
      Log.debug("The helper responded with its version")
      reply(Version(rawVersion))
    })
  }

  static func installChef(reply: @escaping (Bool) -> Void) {
    usingHelper(block: { helper in
      helper.installChef(reply: { success in
        Log.debug("Helper worked on installation")
        reply(success)
      })
    })
  }

  static func uninstallChef(reply: @escaping (Bool) -> Void) {
    usingHelper(block: { helper in
      helper.uninstallHelper(reply: { success in
        Log.debug("Helper worked on uninstallation")
        reply(success)
      })
    })
  }

  static func uninstallHelper(reply: @escaping (Bool) -> Void) {
    usingHelper(block: { helper in
      helper.uninstallHelper(reply: { success in
        Log.debug("Helper worked on the imploding")
        reply(success)
      })
    })
  }

  static func usingHelper(block: @escaping (HelperProtocol) -> Void) {
    Log.debug("Checking helper connection")
    let helper = self.connection()?.remoteObjectProxyWithErrorHandler({ error in
      Log.debug("Oh no, no connection to helper")
      Log.debug(error.localizedDescription)
    }) as! HelperProtocol
    block(helper)
  }

  static func connection() -> NSXPCConnection? {
    if (self.xpcConnection != nil) { return self.xpcConnection }

    self.xpcConnection = NSXPCConnection(machServiceName: Identifiers.helper.rawValue, options: NSXPCConnection.Options.privileged)
    self.xpcConnection!.exportedObject = self
    self.xpcConnection!.remoteObjectInterface = NSXPCInterface(with:HelperProtocol.self)

    self.xpcConnection!.interruptionHandler = {
      self.xpcConnection?.interruptionHandler = nil
      OperationQueue.main.addOperation(){
        self.xpcConnection = nil
        Log.debug("XPC Connection interrupted - the Helper probably crashed.")
        Log.debug("You mght find a crash report at /Library/Logs/DiagnosticReports")
      }
    }

    self.xpcConnection!.invalidationHandler = {
      self.xpcConnection?.invalidationHandler = nil
      OperationQueue.main.addOperation(){
        self.xpcConnection = nil
        Log.debug("XPC Connection Invalidated")
      }
    }

    self.xpcConnection?.resume()
    return self.xpcConnection
  }

}
