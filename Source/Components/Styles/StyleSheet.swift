import UIKit

public protocol StyleSheetProtocol {}

public struct StyleSheet: StyleSheetProtocol {
  public var text = TextStyleSheet()
  public init() {}
}

public struct TextStyleSheet {
  public init() {}
//  public var largeTytle: TextStyleProtocol = TextStyle().withFont(UIFont.preferredFont(forTextStyle: .largeTitle))
  public var title1: TextStyleProtocol = TextStyle().withFont(UIFont.preferredFont(forTextStyle: .title1))
  public var title2: TextStyleProtocol = TextStyle().withFont(UIFont.preferredFont(forTextStyle: .title2))
  public var title3: TextStyleProtocol = TextStyle().withFont(UIFont.preferredFont(forTextStyle: .title3))
  public var headline: TextStyleProtocol = TextStyle().withFont(UIFont.preferredFont(forTextStyle: .headline))
  public var body: TextStyleProtocol = TextStyle().withFont(UIFont.preferredFont(forTextStyle: .body))
  public var callout: TextStyleProtocol = TextStyle().withFont(UIFont.preferredFont(forTextStyle: .callout))
  public var subhead: TextStyleProtocol = TextStyle().withFont(UIFont.preferredFont(forTextStyle: .subheadline))
  public var footnote: TextStyleProtocol = TextStyle().withFont(UIFont.preferredFont(forTextStyle: .footnote))
  public var caption1: TextStyleProtocol = TextStyle().withFont(UIFont.preferredFont(forTextStyle: .caption1))
  public var caption2: TextStyleProtocol = TextStyle().withFont(UIFont.preferredFont(forTextStyle: .caption2))
}
