import Foundation

@objc(HelperProtocol)

protocol HelperProtocol {
  func version(reply: (String) -> Void)

  func installChef(reply: (Bool) -> Void)
}
