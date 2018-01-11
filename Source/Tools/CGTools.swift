import CoreGraphics

public extension CGSize {
  public static var maxSize: CGSize {
    return CGSize(width: CGFloat.greatestFiniteMagnitude,
                  height: CGFloat.greatestFiniteMagnitude)
  }
}

extension CGSize {
  func inset(h: CGFloat, v: CGFloat) -> CGSize {
    return CGSize(width: max(0, width - h),
                  height: max(0, height - v))
  }
}

extension CGSize {
  func constrained(by range: SizeRange) -> CGSize {
    return CGSize(width: max(range.min.width, min(range.max.width, width)),
                  height: max(range.min.height, min(range.max.height, height)))
  }
}

extension CGPoint {
  static func +(left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x,
                   y: left.y + right.y)
  }
}

func ceil(_ size: CGSize) -> CGSize {
  return CGSize(width: ceil(size.width),
                height: ceil(size.height))
}

func ceil(_ point: CGPoint) -> CGPoint {
  return CGPoint(x: ceil(point.x),
                 y: ceil(point.y))
}
