import UIKit

open class CollectionViewCell: UICollectionViewCell, NodeUpdatable, UICollectionViewDelegate {

  public let view: UICollectionView
  public var driver: CollectionDriver!

  public override init(frame: CGRect) {
    let layout = CollectionViewLayout()
    let dataSource = NodeCollectionViewDataSource()
    layout.dataSource = dataSource

    self.view = UICollectionView(frame: .zero, collectionViewLayout: layout)
    super.init(frame: frame)

    view.dataSource = dataSource
    view.backgroundColor = .green
    view.showsHorizontalScrollIndicator = false
    view.bounces = false
    view.alwaysBounceVertical = false
    view.delegate = self

    contentView.addSubview(view)
    registerCells()
  }

  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  open func registerCells() {
    view.registerClasses([ImageCell.self,
                                    ViewCell.self,
                                    TextCell.self,
                                    CollectionViewCell.self])
  }

  open func update(node: Node) {
    if let state = node.state as? CollectionComponentState {
      let driver = state.driver
      let dataSource = driver.nodeDataSource
      view.dataSource = dataSource
      (view.collectionViewLayout as! CollectionViewLayout).dataSource = dataSource
      view.reloadData()

      view.backgroundColor = state.backgroundColor
    }
  }

  override open func layoutSubviews() {
    super.layoutSubviews()
    view.frame = bounds
  }
}
