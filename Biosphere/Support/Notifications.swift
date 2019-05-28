import Foundation

extension Notification.Name {
  static let missingAutomationPermission = Notification.Name("\(BundleIdentifier.string).notifications.missingAutomationPermission")
  static let forgetAutomationPermission = Notification.Name("\(BundleIdentifier.string).notifications.forgetAutomationPermission")
  static let dependenciesChanged = Notification.Name("\(BundleIdentifier.string).notifications.dependenciesChanged")
}
