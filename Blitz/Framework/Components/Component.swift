import CoreGraphics

protocol Component: class {
  var parent: Component? {get set}
  var reloadDelegate: ComponentReloadDelegate? {get set}
  func node(for context: ComponentContext) -> Node
  func didSelectComponents(components: [Component])
}

protocol ComponentReloadDelegate: class {
  func reload(component: Component)
}

class ComponentBase: Component {
  weak var parent: Component?
  weak var reloadDelegate: ComponentReloadDelegate?
  
  func node(for context: ComponentContext) -> Node {
    return Node()
  }
  
  func didSelectComponents(components: [Component]) {
    var components = components
    components.append(self)
    parent?.didSelectComponents(components: components)
  }
}
