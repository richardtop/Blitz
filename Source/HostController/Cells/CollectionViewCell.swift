import UIKit

public protocol CollectionViewCellDisplayDelegate: class {
  func controller(controller: CollectionViewCell, willDisplayItem indexPath: IndexPath)
}

open class CollectionViewCell: UICollectionViewCell, NodeUpdatable, UICollectionViewDelegate {

  public let collectionView: UICollectionView
  public var driver: CollectionDriver!
  // This is driver. Need to think of reference cycles and check for memory leaks
  public weak var displayDelegate: CollectionViewCellDisplayDelegate?
  public var dataSource: NodeCollectionViewDataSource? {
    return collectionView.dataSource as? NodeCollectionViewDataSource
  }

  public override init(frame: CGRect) {
    let layout = CollectionViewLayout(direction: .vertical)
    let dataSource = NodeCollectionViewDataSource()
    layout.dataSource = dataSource

    self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    super.init(frame: frame)

    collectionView.dataSource = dataSource
    collectionView.showsHorizontalScrollIndicator = false
    collectionView.bounces = true
    collectionView.alwaysBounceVertical = true
    collectionView.delegate = self

    collectionView.backgroundColor = .clear

    contentView.addSubview(collectionView)
    registerCells()
  }

  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  open func registerCells() {
    collectionView.registerClasses([ImageCell.self,
                                    ViewCell.self,
                                    TextCell.self,
                                    SearchCell.self,
                                    ProgressCell.self,
                                    CollectionViewCell.self])
  }

  open func update(node: Node) {
    if let state = node.state as? CollectionComponentState {
      let driver = state.driver
      attach(driver: driver)
      collectionView.reloadData()
    }
  }

  open func attach(driver: CollectionDriver) {
    let dataSource = driver.dataSource
    collectionView.dataSource = dataSource
    (collectionView.collectionViewLayout as! CollectionViewLayout).dataSource = dataSource
  }

  open func detachDriver() {
    collectionView.dataSource = nil
    (collectionView.collectionViewLayout as! CollectionViewLayout).dataSource = nil
  }

  open override func prepareForReuse() {
    super.prepareForReuse()
    detachDriver()
  }

  override open func layoutSubviews() {
    super.layoutSubviews()
    collectionView.frame = bounds
  }


  open func reloadData() {
    collectionView.reloadData()
  }

  open func reloadItems(at indexPaths: [IndexPath], animated: Bool = true) {
    if !animated {
      UIView.performWithoutAnimation {
        self.collectionView.reloadItems(at: indexPaths)
      }
    } else {
      self.collectionView.reloadItems(at: indexPaths)
    }
  }

  open func reloadSection(sections: IndexSet, animated: Bool = true) {
    if !animated {
      UIView.performWithoutAnimation {
        self.collectionView.reloadSections(sections)
      }
    } else {
      collectionView.reloadSections(sections)
    }
  }

  // TODO: Maybe, Driver should use delegate methods instead of view?
  open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let node = dataSource?.itemAtIndexPath(indexPath: indexPath).node
    node?.component?.didSelectComponents(components: [])
  }


  open func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
    return true
  }

  open func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
    return true
  }

  open func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
    print(indexPath)
  }

  open func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
  }

  open func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    displayDelegate?.controller(controller: self, willDisplayItem: indexPath)
  }
}
