import Foundation

open class CollectionDriver: ComponentReloadDelegate, CollectionViewCellDisplayDelegate {

  // Or provider?
  public var components = [Component]()
  public var dataSource = NodeCollectionViewDataSource()
  public var context: ComponentContext!

  open func controller(controller: CollectionViewCell, willDisplayItem indexPath: IndexPath) {

  }
  
  open func reload(component: Component) {
//    let b = components.index(where: {$0===component})!
//    let newSubnodes = subnodes(component: component)
//    let newDataSource = collectionView.dataSource) as! NodeCollectionViewDataSource
//    newDataSource.setSubnodes(subnodes: newSubnodes, at: b)
//
//    let newLayout = CollectionViewLayout()
//    newLayout.dataSource = newDataSource
//
//
//    nodeDataSource = newDataSource
//
//    viewController.collectionView.dataSource = newDataSource
//
//
//    viewController.reloadItems(at: [IndexPath(item: 1, section: 0)], animated: true)
  }

  var maxDimension: CGFloat = 0

  var direction: CollectionComponentState.Direction = .vertical

  func update(direction: CollectionComponentState.Direction) {
    self.direction = direction
    var nodes = [[Subnode]]()

    for component in components {
      component.reloadDelegate = self
      switch direction {
      case .horizontal:
        maxDimension = max(maxDimension, component.node(for: context).size.height)
      case .vertical:
        maxDimension = max(maxDimension, component.node(for: context).size.width)
      }
      let node = self.subnodes(component: component)
      nodes.append(node)
    }
    dataSource.data = nodes
  }

  // Experimental, slow performance
  func internalSize() -> CGSize {
    let layout = CollectionViewLayout(direction: direction == .horizontal ? .horizontal : .vertical)
    layout.dataSource = dataSource
    layout.prepare()

    switch direction {
    case .horizontal:
      return CGSize(width: layout.collectionViewContentSize.width, height: maxDimension)
    case .vertical:
      return CGSize(width: maxDimension, height: layout.collectionViewContentSize.height)
    }
  }

  open func recalculateLayout() {
    let nodes = processNew(components: components)
    self.dataSource.data = nodes
  }

  open func appendNewComponents(components: [Component]) {
    let nodes = processNew(components: components)
    self.components.append(contentsOf: components)
    self.dataSource.append(sections: nodes)
  }

  open func replace(components: [Component]) {
    let nodes = processNew(components: components)
    self.components = components
    self.dataSource.data = nodes
  }

  func processNew(components: [Component]) -> [[Subnode]] {
    var nodes = [[Subnode]]()
    for component in components {
      component.reloadDelegate = self
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
