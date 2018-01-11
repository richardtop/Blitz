import CoreGraphics

public struct SizeRange {
  public var min: CGSize
  public var max: CGSize
  
  public init(min: CGSize = .zero, max: CGSize = .maxSize) {
    self.min = min
    self.max = max
  }
}
