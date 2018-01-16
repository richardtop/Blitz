import UIKit

open class ImageCell: CollectionCellBase<UIImageView>, NodeUpdatable {
  open func update(node: Node) {
    if let image = node.state as? UIImage? {
      view.image = image
    }
  }
}
