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

  var state: CollectionComponentState?

  func updateState(state: CollectionComponentState) {
    self.state = state

    var nodes = [[Subnode]]()

    for component in components {
      component.reloadDelegate = self
      switch state.direction {
      case .horizontal:
        maxDimension = max(maxDimension, component.node(for: context).size.height)
      case .vertical:
        maxDimension = max(maxDimension, component.node(for: context).size.width)
      }
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

    guard let state = state else {return .zero}
    switch state.direction {
    case .horizontal:
      return CGSize(width: layout.collectionViewContentSize.width, height: maxDimension)
    case .vertical:
      return CGSize(width: maxDimension, height: layout.collectionViewContentSize.height)
    }
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
