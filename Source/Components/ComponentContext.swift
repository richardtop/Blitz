import Foundation

public struct ComponentContext {
  public var sizeRange: SizeRange
  public var styleSheet: StyleSheetProtocol
  
  public init(sizeRange: SizeRange, styleSheet: StyleSheetProtocol) {
    self.sizeRange = sizeRange
    self.styleSheet = styleSheet
  }
}
