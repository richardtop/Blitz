import Foundation

open class CollectionDriver: ComponentReloadDelegate, CollectionControllerDisplayDelegate {

  // Or provider?
  public var components = [Component]()
  public var nodeDataSource = NodeCollectionViewDataSource()
  public var context: ComponentContext!

  open func controller(controller: CollectionController, willDisplayItem indexPath: IndexPath) {

  }
  
  open func reload(component: Component) {

  }

  var maxDimension: CGFloat = 0

  open func reloadDriver() {
    var nodes = [[Subnode]]()
    for component in components {
      component.reloadDelegate = self
      maxDimension = max(maxDimension, component.node(for: context).size.height)
      let node = self.subnodes(component: component)
      nodes.append(node)
    }
    nodeDataSource.data = nodes
  }
  // Experimental
  func internalSize() -> CGSize {
    let layout = CollectionViewLayout(direction: .horizontal)
    layout.dataSource = nodeDataSource
    layout.prepare()
    return CGSize(width: layout.collectionViewContentSize.width, height: maxDimension)
  }

  open func appendNewComponents(components: [Component]) {
    var nodes = [[Subnode]]()
    for component in components {
      component.reloadDelegate = self
      let node = self.subnodes(component: component)
      nodes.append(node)
    }
    self.components.append(contentsOf: components)
    self.nodeDataSource.append(sections: nodes)
  }

  open func subnodes(component: Component) -> [Subnode] {
    let subnodes = NodeTools.simplifiedNodeHierarchy(node: component.node(for: context), at: .zero, zIndex: 0)
    return subnodes
  }
}
