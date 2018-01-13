import Blitz

public class StaticLogicController: ComponentReloadDelegate, CollectionControllerDisplayDelegate {
  public var viewController: CollectionController
  public var nodeDataSource: NodeCollectionViewDataSource
  public var componentProvider: ComponentProvider

  public var components = [Component]()
  public var context: ComponentContext

  var offsetMarker: Int?

  public init(context: ComponentContext,
              componentProvider: ComponentProvider) {
    self.context = context
    self.componentProvider = componentProvider

    self.nodeDataSource = NodeCollectionViewDataSource()
    self.viewController = CollectionController()

    viewController.dataSource = nodeDataSource
    viewController.displayDelegate = self
//    viewController.logicController = self

    components = [Component]()
    self.loadNextData()
  }

  public func controller(controller: CollectionController, willDisplayItem indexPath: IndexPath) {
    let section = indexPath.section
    if section + 10 > nodeDataSource.numberOfSections() {
      loadNextData()
    }
  }

  func loadNextData() {
    loadDataWith(offset: components.count, count: 10)
  }

  func loadDataWith(offset: Int, count: Int) {
    if offsetMarker != nil {
      return
    }

    offsetMarker = offset

    DispatchQueue.global(qos: .background).async {
      self.componentProvider.components(offset: offset, count: count, completion: { (result) in
        switch result {
        case .Failure(let error):
          print(error)
        case .Success(let components):
          self.appendNewComponents(components: components)
          self.offsetMarker = nil
          self.reloadData()
        }
      })
    }
  }

  func appendNewComponents(components: [Component]) {
    var nodes = [[Subnode]]()
    for component in components {
      component.reloadDelegate = self
      let node = self.subnodes(component: component)
      nodes.append(node)
    }
    self.components.append(contentsOf: components)
    self.nodeDataSource.append(sections: nodes)
  }

  func subnodes(component: Component) -> [Subnode] {
    let subnodes = NodeTools.simplifiedNodeHierarchy(node: component.node(for: context), at: .zero, zIndex: 0)
    return subnodes
  }

  func reloadData() {
    DispatchQueue.main.async {
      self.viewController.reloadData()
    }
  }

  public func reload(component: Component) {
    print("ComponentLoginController wants reloadd")
    let b = components.index(where: {$0===component})!
    let newSubnodes = subnodes(component: component)
    nodeDataSource.setSubnodes(subnodes: newSubnodes, at: b)

    viewController.reloadSection(sections: IndexSet([b]))
  }
}

