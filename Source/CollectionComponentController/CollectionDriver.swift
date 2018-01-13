//
//  CollectionDriver.swift
//  Blitz
//
//  Created by Richard Topchii on 13/01/2018.
//

import Foundation

public class CollectionDriver: ComponentReloadDelegate, CollectionControllerDisplayDelegate {

  var components = [Component]()
  var nodeDataSource = NodeCollectionViewDataSource()
  var context: ComponentContext!

  public func controller(controller: CollectionController, willDisplayItem indexPath: IndexPath) {

  }
  
  public func reload(component: Component) {

  }

  func reloadDriver() {
    var nodes = [[Subnode]]()
    for component in components {
      component.reloadDelegate = self
      let node = self.subnodes(component: component)
      nodes.append(node)
    }
    nodeDataSource.data = nodes
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
}
