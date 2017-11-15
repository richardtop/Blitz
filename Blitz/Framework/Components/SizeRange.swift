import CoreGraphics

struct SizeRange {
  var min: CGSize
  var max: CGSize
  
  init(min: CGSize = .zero, max: CGSize = .maxSize) {
    self.min = min
    self.max = max
  }
}
