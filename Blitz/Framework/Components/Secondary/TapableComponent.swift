import UIKit

struct TapableComponentState {
  var component: Component
  var onTapCallback: (Component) -> Void
}

class TapableComponent: ComponentBase {
  var state: TapableComponentState
  
  init(_ component: Component, _ onTapCallback: @escaping (Component) -> Void) {
    self.state = TapableComponentState(component: component, onTapCallback: onTapCallback)
    super.init()
    component.parent = self
  }
  
  override func node(for context: ComponentContext) -> Node {
    var node = Node()
    node.component = self
    
    let childNode = state.component.node(for: context)
    node.size = childNode.size.constrained(by: context.sizeRange)
    node.subnodes = [Subnode(node: childNode, at: .zero)]

    return node
  }
  
  override func didSelectComponents(components: [Component]) {
    state.onTapCallback(state.component)
    var components = components
    components.append(self)
    parent?.didSelectComponents(components: components)
  }
}
