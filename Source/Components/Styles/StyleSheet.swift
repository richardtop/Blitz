import UIKit

public struct StyleSheet {
  public var text = TextStyleSheet()
  public init() {}
}

public struct TextStyleSheet {
  public var title: TextStyleProtocol = TextStyle().withFont(.boldSystemFont(ofSize: 30))
  public var subtitle: TextStyleProtocol = TextStyle().ofSize(20)
  public var heading1: TextStyleProtocol = TextStyle().withFont(.boldSystemFont(ofSize: 18))
  public var heading2: TextStyleProtocol = TextStyle().withFont(.boldSystemFont(ofSize: 16))
  public var heading3: TextStyleProtocol = TextStyle().ofSize(14)
  public var headingAccent: TextStyleProtocol = TextStyle().withFont(.boldSystemFont(ofSize: 16)).ofColor(.red)
  public var body: TextStyleProtocol = TextStyle()
}
