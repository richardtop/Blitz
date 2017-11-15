import UIKit

class CollectionCellBase<T: UIView>: UICollectionViewCell {
  let view = T()
  
  override var isHighlighted: Bool {
    didSet {
      alpha = isHighlighted ? 0.5 : 1
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.addSubview(view)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    view.frame = bounds
  }
}
