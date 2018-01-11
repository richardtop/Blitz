import Foundation

public extension NSAttributedString {
  public convenience init(string: String, style: TextStyleProtocol) {
    self.init(string: string, attributes: style.attributes)
  }
}
