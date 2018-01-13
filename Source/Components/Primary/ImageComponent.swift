import UIKit

class ImageComponent: ComponentBase {
  let image: UIImage?
  
  init(image: UIImage?) {
    self.image = image
  }
  
  override func node(for context: ComponentContext) -> Node {
    var node = Node()
    node.state = image
    node.component = self
    node.viewType = ImageCell.self
    
    let imageSize = image?.size ?? .zero
    node.size = imageSize.constrained(by: context.sizeRange)
    
    return node
  }
}
