import UIKit

public protocol CollectionControllerDisplayDelegate: class {
  func controller(controller: CollectionController, willDisplayItem indexPath: IndexPath)
}

public class CollectionController: UIViewController, UICollectionViewDelegate {
  public lazy var collectionView: UICollectionView = { [unowned self] in
    let layout = CollectionViewLayout()
    let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
    view.backgroundColor = .white
    view.showsHorizontalScrollIndicator = false
    view.bounces = true
    view.alwaysBounceVertical = true
    view.delegate = self
    return view
    }()
  
  public var dataSource: NodeCollectionViewDataSource? {
    get {
      return collectionView.dataSource as? NodeCollectionViewDataSource
    }
    set(new) {
      collectionView.dataSource = new
      (collectionView.collectionViewLayout as? CollectionViewLayout)?.dataSource = new
    }
  }
  
  public weak var displayDelegate: CollectionControllerDisplayDelegate?
  
  
  override public func loadView() {
    self.view = collectionView
  }
  
  override public func viewDidLoad() {
    super.viewDidLoad()
    registerCells()
  }
  
  func registerCells() {
    collectionView.registerClasses([ImageCell.self,
                                    ViewCell.self,
                                    TextCell.self])
  }
  
  public func reloadData() {
    collectionView.reloadData()
  }
  
  public func reloadItems(at indexPaths: [IndexPath], animated: Bool = true) {
    if !animated {
      UIView.performWithoutAnimation {
        self.collectionView.reloadItems(at: indexPaths)
      }
    } else {

//      collectionView.performBatchUpdates({
        self.collectionView.reloadItems(at: indexPaths)
//      }, completion: nil)

    }
  }
  
  public func reloadSection(sections: IndexSet, animated: Bool = true) {
    if !animated {
      UIView.performWithoutAnimation {
        self.collectionView.reloadSections(sections)
      }
    } else {
      collectionView.reloadSections(sections)
    }
  }

  public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let node = dataSource?.itemAtIndexPath(indexPath: indexPath).node
    node?.component?.didSelectComponents(components: [])
  }
  
  
  public func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  public func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  public func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
    print(indexPath)
  }
  
  public func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
  }
  
  public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    displayDelegate?.controller(controller: self, willDisplayItem: indexPath)
  }
}
