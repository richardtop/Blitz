import UIKit

class CollectionViewLayout: UICollectionViewLayout {
  
  var cache = [[UICollectionViewLayoutAttributes]]()
  var lastCalculatedBottomY: CGFloat = 0
  
  var dataSource: NodeCollectionViewDataSource!
  
  override func prepare() {
    super.prepare()

    var groupsOfSectionsAttributes = [[UICollectionViewLayoutAttributes]]()
    var bottom: CGFloat = 0
    
    if dataSource.numberOfSections() == 0 {
      return
    }
    
    for s in 0...dataSource.numberOfSections() - 1 {
      var sectionAttributes = [UICollectionViewLayoutAttributes]()
      var sectionGroupsAttributes: CGFloat = 0
      
      if dataSource.numberOfItems(in: s) == 0 {
        return
      }

      for i in 0...dataSource.numberOfItems(in: s) - 1 {
        let indexPath = IndexPath(indexes: [s, i])
        let subnode = dataSource.itemAtIndexPath(indexPath: indexPath)
        let nodeOrigin = subnode.origin
        let origin = CGPoint(x: nodeOrigin.x, y: nodeOrigin.y + bottom)
        let size = subnode.node.size

        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attributes.frame = CGRect(origin: origin, size: size)
        attributes.zIndex = subnode.node.zIndex

        sectionAttributes.append(attributes)
        sectionGroupsAttributes = max(sectionGroupsAttributes, bottomY(subnode: subnode))
      }

      groupsOfSectionsAttributes.append(sectionAttributes)
      bottom += sectionGroupsAttributes
    }
    lastCalculatedBottomY = bottom
    cache = groupsOfSectionsAttributes
  }
  
  override var collectionViewContentSize: CGSize {
    let bounds = collectionView?.bounds ?? .zero
    return CGSize(width: bounds.width, height: lastCalculatedBottomY)
  }
  
  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    return cache.joined().filter{$0.frame.intersects(rect)}
  }
  
  override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    return cache[indexPath.section][indexPath.item]
  }
  
  override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
    guard let currentSize = collectionView?.bounds.size else {return true}
    let newSize = newBounds.size
    
    if currentSize != newSize {
      return true
    }
    
    return false
  }
  
  private func bottomY(subnode: Subnode) -> CGFloat {
    return subnode.origin.y + subnode.node.size.height
  }
}
