import UIKit

open class ImageComponent: ComponentBase {
  public let image: UIImage?
  
  public init(image: UIImage?) {
    self.image = image
  }
  
  override open func node(for context: ComponentContext) -> Node {
    var node = Node()
    node.state = image
    node.component = self
    node.viewType = ImageCell.self
    
    let imageSize = image?.size ?? .zero
    node.size = imageSize.constrained(by: context.sizeRange)
    
    return node
  }
}
