import Foundation

public struct ComponentContext {
  public var sizeRange: SizeRange
  public var styleSheet: StyleSheet
  
  public init(sizeRange: SizeRange, styleSheet: StyleSheet) {
    self.sizeRange = sizeRange
    self.styleSheet = styleSheet
  }
}
