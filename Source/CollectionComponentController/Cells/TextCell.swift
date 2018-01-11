import UIKit

class TextCell: CollectionCellBase<UILabel>, NodeUpdatable {
  override init(frame: CGRect) {
    super.init(frame: frame)
    view.numberOfLines = 0
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func update(node: Node) {
    if let text = node.state as? NSAttributedString {
      view.attributedText = text
    }
  }
}
