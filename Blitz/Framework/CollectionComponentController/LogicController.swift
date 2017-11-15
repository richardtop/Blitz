import UIKit

public enum Result<T> {
  case Success(T)
  case Failure(Error)
}

protocol ComponentProvider {
  func components(offset: Int, count: Int, completion: @escaping (Result<[Component]>) -> Void)
}

class LogicController: ComponentReloadDelegate, CollectionControllerDisplayDelegate {
  var viewController: CollectionController
  var nodeDataSource: NodeCollectionViewDataSource
  var componentProvider: ComponentProvider
  
  var components = [Component]()
  var context: ComponentContext
  
  var offsetMarker: Int?
  
  init(context: ComponentContext,
       componentProvider: ComponentProvider) {
    self.context = context
    self.componentProvider = componentProvider
    
    self.nodeDataSource = NodeCollectionViewDataSource()
    self.viewController = CollectionController()
    
    viewController.dataSource = nodeDataSource
    viewController.displayDelegate = self
    viewController.logicController = self
  
    components = [Component]()
    self.loadNextData()
  }
  
  func controller(controller: CollectionController, willDisplayItem indexPath: IndexPath) {
    let section = indexPath.section
    if section + 150 > nodeDataSource.numberOfSections() {
      loadNextData()
    }
  }
  
  func loadNextData() {
    loadDataWith(offset: components.count, count: 200)
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
  
  func reload(component: Component) {
    print("ComponentLoginController wants reloadd")
    let b = components.index(where: {$0===component})!
    let newSubnodes = subnodes(component: component)
    nodeDataSource.setSubnodes(subnodes: newSubnodes, at: b)
    
    viewController.reloadSection(sections: IndexSet([b]))
  }
}
