import UIKit

open class ViewCell: UICollectionViewCell, NodeUpdatable {
  public typealias ViewConfigurationBlock = (UIView) -> ()
  
    open override var isHighlighted: Bool {
      didSet {
        alpha = isHighlighted ? 0.5 : 1
      }
    }
  
  open func update(node: Node) {
    if let block = node.state as? ViewConfigurationBlock {
      block(self)
    }
  }

  open override func prepareForReuse() {
    super.prepareForReuse()
    backgroundColor = .clear
    layer.shadowOpacity = 0
  }
}
