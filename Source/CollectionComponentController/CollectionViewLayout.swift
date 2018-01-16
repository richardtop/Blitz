import UIKit

open class CollectionViewLayout: UICollectionViewLayout {
  public enum Direction {
    case horizontal
    case vertical
  }

  let direction: Direction
  
  var cache = [[UICollectionViewLayoutAttributes]]()
  var leadingEdgeValue: CGFloat = 0
  
  var dataSource: NodeCollectionViewDataSource!

  init(direction: Direction = .vertical) {
    self.direction = direction
    super.init()
  }

  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override open func prepare() {
    super.prepare()
    var groupsOfSectionsAttributes = [[UICollectionViewLayoutAttributes]]()
    var currentLeadingEdge: CGFloat = 0
    
    if dataSource.numberOfSections() == 0 {
      return
    }
    
    for s in 0...dataSource.numberOfSections() - 1 {
      var sectionAttributes = [UICollectionViewLayoutAttributes]()
      var sectionGroupsAttributes: CGFloat = 0
      
      if dataSource.numberOfItems(in: s) == 0 {
        return
      }

      func edge(subnode: Subnode) -> CGFloat {
        switch direction {
        case .horizontal:
          return subnode.origin.x + subnode.node.size.width
        case .vertical:
          return subnode.origin.y + subnode.node.size.height
        }
      }

      for i in 0...dataSource.numberOfItems(in: s) - 1 {
        let indexPath = IndexPath(indexes: [s, i])
        let subnode = dataSource.itemAtIndexPath(indexPath: indexPath)
        let nodeOrigin = subnode.origin
        var origin = CGPoint.zero
        switch direction {
        case .horizontal:
          origin = CGPoint(x: nodeOrigin.x + currentLeadingEdge, y: nodeOrigin.y)
        case .vertical:
          origin = CGPoint(x: nodeOrigin.x, y: nodeOrigin.y + currentLeadingEdge)
        }

        let size = subnode.node.size

        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attributes.frame = CGRect(origin: origin, size: size)
        attributes.zIndex = subnode.node.zIndex

        sectionAttributes.append(attributes)
        sectionGroupsAttributes = max(sectionGroupsAttributes, edge(subnode: subnode))
      }

      groupsOfSectionsAttributes.append(sectionAttributes)
      currentLeadingEdge += sectionGroupsAttributes
    }
    leadingEdgeValue = currentLeadingEdge
    cache = groupsOfSectionsAttributes
  }
  
  override open var collectionViewContentSize: CGSize {
    let bounds = collectionView?.bounds ?? .zero
    switch direction {
    case .horizontal:
      return CGSize(width: leadingEdgeValue, height: bounds.height)
    case .vertical:
      return CGSize(width: bounds.width, height: leadingEdgeValue)
    }
  }
  
  override open func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    return cache.joined().filter{$0.frame.intersects(rect)}
  }
  
  override open func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    return cache[indexPath.section][indexPath.item]
  }
  
  override open func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
    guard let currentSize = collectionView?.bounds.size else {return true}
    let newSize = newBounds.size
    
    if currentSize != newSize {
      return true
    }
    
    return false
  }


}
