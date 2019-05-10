import Foundation

@objc(HelperProtocol)

protocol HelperProtocol {
  func version(reply: @escaping (String) -> Void)

  func installChef(reply: @escaping (Bool) -> Void)
  func uninstallHelper(reply: @escaping (Bool) -> Void)
}
