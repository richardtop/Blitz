import UIKit

protocol TextStyleProtocol {
  var attributes: [NSAttributedStringKey:Any] {get}
}

struct TextStyle: TextStyleProtocol {
  var attributes: [NSAttributedStringKey:Any]
  
  init() {
    self.attributes = [.font:UIFont.systemFont(ofSize: UIFont.systemFontSize)]
  }
  
  init(attributes: [NSAttributedStringKey:Any]) {
    self.attributes = attributes
  }
  
  func withFont(_ font: UIFont) -> TextStyle {
    return fontStyleBySetting(attribute: font, forKey: .font)
  }
  
  func ofSize(_ size: CGFloat) -> TextStyle {
    guard let currentFont = attributes[.font] as? UIFont else {return self}
    let newFont = currentFont.withSize(size)
    return withFont(newFont)
  }
  
  func ofColor(_ color: UIColor) -> TextStyle {
    return fontStyleBySetting(attribute: color, forKey: .foregroundColor)
  }
  
  func fontStyleBySetting(attribute: Any?, forKey key: NSAttributedStringKey) -> TextStyle {
    return fontStyleBySettingAttributes(newAttributes: [key:attribute])
  }
  
  func fontStyleBySettingAttributes(newAttributes: [NSAttributedStringKey:Any]) -> TextStyle {
    var copy = self
    for key in newAttributes.keys {
      copy.attributes[key] = newAttributes[key]
    }
    return copy
  }
}
