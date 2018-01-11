import CoreGraphics

public protocol Component: class {
  var parent: Component? {get set}
  var reloadDelegate: ComponentReloadDelegate? {get set}
  func node(for context: ComponentContext) -> Node
  func didSelectComponents(components: [Component])
}

public protocol ComponentReloadDelegate: class {
  func reload(component: Component)
}

open class ComponentBase: Component {
  weak public var parent: Component?
  weak public var reloadDelegate: ComponentReloadDelegate?

  public init() {}
  
  open func node(for context: ComponentContext) -> Node {
    return Node()
  }
  
  open func didSelectComponents(components: [Component]) {
    var components = components
    components.append(self)
    parent?.didSelectComponents(components: components)
  }
}
