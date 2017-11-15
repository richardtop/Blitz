import Foundation

extension NSAttributedString {
  convenience init(string: String, style: TextStyleProtocol) {
    self.init(string: string, attributes: style.attributes)
  }
}
