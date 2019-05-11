import Foundation

extension NSRect: CustomStringConvertible {
  public var description: String {
    let x = String(describing: origin.x).replacingOccurrences(of: ".0", with: "")
    let y = String(describing: origin.y).replacingOccurrences(of: ".0", with: "")

    let width = String(describing: size.width).replacingOccurrences(of: ".0", with: "")
    let height = String(describing: size.height).replacingOccurrences(of: ".0", with: "")

    return "(👈🏻\(x) 🤘🏻\(width) 👇🏻\(y) 🤙🏻\(height))"
  }
}
