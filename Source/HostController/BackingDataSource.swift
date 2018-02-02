import UIKit

open class BackingDataSource: DataSource<Subnode> {
  public enum Direction {
    case horizontal
    case vertical
  }

  let direction: Direction

  var cache = [[Subnode]]()
  var leadingEdgeValue: CGFloat = 0

  public init(direction: Direction = .vertical) {
    self.direction = direction
    super.init()
  }

   open func prepare() {
    print("Prepare")
    var groupsOfSectionsAttributes = [[Subnode]]()
    var currentLeadingEdge: CGFloat = 0

    if numberOfSections() == 0 {
      return
    }

    for s in 0...numberOfSections() - 1 {
      var sectionAttributes = [Subnode]()
      var sectionGroupsAttributes: CGFloat = 0

      if numberOfItems(in: s) == 0 {
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

      for i in 0...numberOfItems(in: s) - 1 {
        let indexPath = IndexPath(indexes: [s, i])
        var subnode = itemAtIndexPath(indexPath: indexPath)
        let nodeOrigin = subnode.origin
        var origin = CGPoint.zero
        switch direction {
        case .horizontal:
          origin = CGPoint(x: nodeOrigin.x + currentLeadingEdge, y: nodeOrigin.y)
        case .vertical:
          origin = CGPoint(x: nodeOrigin.x, y: nodeOrigin.y + currentLeadingEdge)
        }

        let size = subnode.node.size

        let frame = CGRect(origin: origin, size: size)


        sectionGroupsAttributes = max(sectionGroupsAttributes, edge(subnode: subnode))
        subnode.origin = origin
        sectionAttributes.append(subnode)
      }

      groupsOfSectionsAttributes.append(sectionAttributes)
      currentLeadingEdge += sectionGroupsAttributes
    }
    leadingEdgeValue = currentLeadingEdge
    cache = groupsOfSectionsAttributes
  }

   open var collectionViewContentSize: CGSize {

    // FIXME:
    let bounds = UIScreen.main.bounds
    var size: CGSize!

    switch direction {
    case .horizontal:
      size = CGSize(width: leadingEdgeValue, height: bounds.height)
    case .vertical:
      size = CGSize(width: bounds.width, height: leadingEdgeValue)
    }

    return size
  }

   open func subnodes(in rect: CGRect) -> [Subnode]? {
    return cache.joined().filter { (subnode) -> Bool in
      let snFrame = CGRect(origin: subnode.origin, size: subnode.node.size)
      return snFrame.intersects(rect)
    }
  }

  public func subnodeAtIndexPath(indexPath: IndexPath) -> Subnode {
    return cache[indexPath.section][indexPath.item]
  }

  open func setSubnode(subnode: Subnode, at indexPath: IndexPath) {
    data[indexPath.section][indexPath.item] = subnode
  }

  open func setSubnodes(subnodes: [Subnode], at section: Int) {
    data[section] = subnodes
  }

  open func append(sections: [[Subnode]]) {
    data.append(contentsOf: sections)
  }

//   open func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
//
//    guard let currentSize = collectionView?.bounds.size else {return true}
//    let newSize = newBounds.size
//
//    if currentSize != newSize {
//      return true
//    }
//
//    return false
//  }
}

