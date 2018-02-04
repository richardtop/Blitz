import UIKit

class BackingView: UIScrollView {
  var components = [Component]()
  var pool = ReusePool()
  var context: ComponentContext!
  var dataSource = BackingDataSource()

  func reloadData() {
    for s in 0...dataSource.numberOfSections() - 1 {
      for i in 0...dataSource.numberOfItems(in: s) - 1 {
        let indexPath = IndexPath(indexes: [s, i])
        let node = dataSource.subnodeAtIndexPath(indexPath: indexPath)
        let viewType = node.node.viewType!
        let subview = pool.dequeue(type: viewType as! UIView.Type)
        if subview.superview == nil {
          addSubview(subview)
        }
        if let v = subview as? NodeUpdatable {
          v.update(node: node.node)
        }
        let frame = CGRect(origin: node.origin, size: node.node.size)
        subview.frame = frame
        subview.layer.zPosition = CGFloat(node.node.zIndex)
        subview.layer.borderColor = UIColor.red.cgColor
        subview.layer.borderWidth = 2
      }
    }
  }

  var lastLoadBounds = CGRect.zero

  override func layoutSubviews() {
    super.layoutSubviews()
    if lastLoadBounds != bounds {
      performLayout()
    }
    lastLoadBounds = bounds
  }

  func performLayout() {
      let visibleRect = CGRect(origin: contentOffset,
                               size: bounds.size)

      let safeRect = visibleRect.insetBy(dx: -200, dy: -200)
      let toRemove = subviews.filter{!$0.frame.intersects(safeRect)}
      pool.enqueue(views: toRemove)
      let sn = dataSource.subnodes(in: visibleRect)
      displaySubnodes(sn ?? [])
  }

  func displaySubnodes(_ subnodes: [Subnode]) {
    for node in subnodes {
      let viewType = node.node.viewType!
      let uniqueId = node.node.uniqueId

      if let oldView = viewWithTag(uniqueId) {
        continue
      }

      let subview = pool.dequeue(type: viewType as! UIView.Type)
      if subview.superview == nil {
        addSubview(subview)
      }
      if let v = subview as? NodeUpdatable {
        v.update(node: node.node)
      }
      subview.tag = uniqueId
      let frame = CGRect(origin: node.origin, size: node.node.size)
      subview.frame = frame
      subview.layer.zPosition = CGFloat(node.node.zIndex)
      subview.layer.borderColor = UIColor.red.cgColor
      subview.layer.borderWidth = 2
    }
  }



  open func appendNewComponents(components: [Component]) {
    let nodes = processNew(components: components)
    self.components.append(contentsOf: components)
    self.dataSource.append(sections: nodes)
    // TODO: recalculate what's needed only
    self.dataSource.prepare()
    contentSize = dataSource.collectionViewContentSize
//        reloadData()
  }

  open func replace(components: [Component]) {
    let nodes = processNew(components: components)
    self.components = components
    self.dataSource.data = nodes
  }

  func processNew(components: [Component]) -> [[Subnode]] {
    var nodes = [[Subnode]]()
    for component in components {
      //      component.reloadDelegate = self
      let node = self.subnodes(component: component)
      nodes.append(node)
    }
    return nodes
  }

  open func subnodes(component: Component) -> [Subnode] {
    let subnodes = NodeTools.simplifiedNodeHierarchy(node: component.node(for: context), at: .zero, zIndex: 0)
    return subnodes
  }
}
