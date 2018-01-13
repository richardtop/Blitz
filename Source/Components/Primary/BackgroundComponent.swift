import UIKit

public struct BackgroundComponentState {
  public var component: Component
  public let configurationBlock: (UIView) -> Void
}

open class BackgroundComponent: ComponentBase {
  public var state: BackgroundComponentState
  
  public init(state: BackgroundComponentState) {
    self.state = state
    super.init()
    self.state.component.parent = self
  }
  
  public convenience init(component: Component, configurationBlock: @escaping (UIView) -> Void) {
    self.init(state: BackgroundComponentState(component: component, configurationBlock: configurationBlock))
  }
  
  override open func node(for context: ComponentContext) -> Node {
    var node = Node()
    node.component = self
    
    let childNode = state.component.node(for: context)
    node.size = childNode.size.constrained(by: context.sizeRange)
    node.size = CGSize(width: .greatestFiniteMagnitude, height: node.size.height).constrained(by: context.sizeRange)
    node.viewType = ViewCell.self
    node.translatesIntoView = true
    node.state = state.configurationBlock
    node.subnodes = [Subnode(node: childNode, at: .zero)]
    
    return node
  }
}
