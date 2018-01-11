import UIKit

public protocol TextStyleProtocol {
  var attributes: [NSAttributedStringKey:Any] {get}
}

public struct TextStyle: TextStyleProtocol {
  public var attributes: [NSAttributedStringKey:Any]
  
  public init() {
    self.attributes = [.font:UIFont.systemFont(ofSize: UIFont.systemFontSize)]
  }
  
  public init(attributes: [NSAttributedStringKey:Any]) {
    self.attributes = attributes
  }
  
  public func withFont(_ font: UIFont) -> TextStyle {
    return fontStyleBySetting(attribute: font, forKey: .font)
  }
  
  public func ofSize(_ size: CGFloat) -> TextStyle {
    guard let currentFont = attributes[.font] as? UIFont else {return self}
    let newFont = currentFont.withSize(size)
    return withFont(newFont)
  }
  
  public func ofColor(_ color: UIColor) -> TextStyle {
    return fontStyleBySetting(attribute: color, forKey: .foregroundColor)
  }
  
  public func fontStyleBySetting(attribute: Any?, forKey key: NSAttributedStringKey) -> TextStyle {
    return fontStyleBySettingAttributes(newAttributes: [key:attribute])
  }
  
  public func fontStyleBySettingAttributes(newAttributes: [NSAttributedStringKey:Any]) -> TextStyle {
    var copy = self
    for key in newAttributes.keys {
      copy.attributes[key] = newAttributes[key]
    }
    return copy
  }
}
