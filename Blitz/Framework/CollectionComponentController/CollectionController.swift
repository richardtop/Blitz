import UIKit

protocol CollectionControllerDisplayDelegate: class {
  func controller(controller: CollectionController, willDisplayItem indexPath: IndexPath)
}

class CollectionController: UIViewController, UICollectionViewDelegate {
  lazy var collectionView: UICollectionView = { [unowned self] in
    let layout = CollectionViewLayout()
    let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
    view.backgroundColor = .white
    view.showsHorizontalScrollIndicator = false
    view.bounces = true
    view.alwaysBounceVertical = true
    view.delegate = self
    return view
    }()
  
  var dataSource: NodeCollectionViewDataSource? {
    get {
      return collectionView.dataSource as? NodeCollectionViewDataSource
    }
    set(new) {
      collectionView.dataSource = new
      (collectionView.collectionViewLayout as? CollectionViewLayout)?.dataSource = new
    }
  }
  
  weak var displayDelegate: CollectionControllerDisplayDelegate?
  
  var logicController: LogicController?
  
  override func loadView() {
    self.view = collectionView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    registerCells()
  }
  
  func registerCells() {
    collectionView.registerClasses([ImageCell.self,
                                    ViewCell.self,
                                    TextCell.self])
  }
  
  func reloadData() {
    collectionView.reloadData()
  }
  
  func reloadItems(at indexPaths: [IndexPath], animated: Bool = true) {
    if !animated {
      UIView.performWithoutAnimation {
        self.collectionView.reloadItems(at: indexPaths)
      }
    } else {
      collectionView.reloadItems(at: indexPaths)
    }
  }
  
  func reloadSection(sections: IndexSet, animated: Bool = true) {
    if !animated {
      UIView.performWithoutAnimation {
        self.collectionView.reloadSections(sections)
      }
    } else {
      collectionView.reloadSections(sections)
    }
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let node = dataSource?.itemAtIndexPath(indexPath: indexPath).node
    node?.component?.didSelectComponents(components: [])
  }
  
  
  func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
  }
  
  func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
  }
  
  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    displayDelegate?.controller(controller: self, willDisplayItem: indexPath)
  }
}
