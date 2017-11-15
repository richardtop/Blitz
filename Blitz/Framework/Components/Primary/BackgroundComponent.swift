import UIKit

struct BackgroundComponentState {
  var component: Component
  let configurationBlock: (UIView) -> Void
}

class BackgroundComponent: ComponentBase {
  var state: BackgroundComponentState
  
  init(state: BackgroundComponentState) {
    self.state = state
    super.init()
    self.state.component.parent = self
  }
  
  convenience init(component: Component, configurationBlock: @escaping (UIView) -> Void) {
    self.init(state: BackgroundComponentState(component: component, configurationBlock: configurationBlock))
  }
  
  override func node(for context: ComponentContext) -> Node {
    var node = Node()
    node.component = self
    
    let childNode = state.component.node(for: context)
    node.size = childNode.size.constrained(by: context.sizeRange)
    node.viewType = ViewCell.self
    node.translatesIntoView = true
    node.state = state.configurationBlock
    node.subnodes = [Subnode(node: childNode, at: .zero)]
    
    return node
  }
}
