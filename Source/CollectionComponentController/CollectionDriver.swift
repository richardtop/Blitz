//
//  CollectionDriver.swift
//  Blitz
//
//  Created by Richard Topchii on 13/01/2018.
//

import Foundation

open class CollectionDriver: ComponentReloadDelegate, CollectionControllerDisplayDelegate {

  public var components = [Component]()
  public var nodeDataSource = NodeCollectionViewDataSource()
  public var context: ComponentContext!

  open func controller(controller: CollectionController, willDisplayItem indexPath: IndexPath) {

  }
  
  open func reload(component: Component) {

  }

  open func reloadDriver() {
    var nodes = [[Subnode]]()
    for component in components {
      component.reloadDelegate = self
      let node = self.subnodes(component: component)
      nodes.append(node)
    }
    nodeDataSource.data = nodes
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
