import UIKit

open class TextCell: CollectionCellBase<UILabel>, NodeUpdatable {
  public override init(frame: CGRect) {
    super.init(frame: frame)
    view.numberOfLines = 0
  }
  
  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  open func update(node: Node) {
    if let text = node.state as? NSAttributedString {
      view.attributedText = text
    }
  }
}
