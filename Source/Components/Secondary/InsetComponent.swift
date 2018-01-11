import UIKit

public struct InsetComponentState {
  public var component: Component
  public let insets: UIEdgeInsets
}

public class InsetComponent: ComponentBase {
  public typealias InsetComponentBuilder = () -> Component
  
  var state: InsetComponentState
  
  public init(state: InsetComponentState) {
    self.state = state
    super.init()
    self.state.component.parent = self
  }
  
  public convenience init(insets: UIEdgeInsets = .zero, component: Component) {
    self.init(state: InsetComponentState(component: component, insets: insets))
  }
  
  public convenience init(insets: UIEdgeInsets = .zero, builder: InsetComponentBuilder) {
    let component = builder()
    self.init(insets: insets, component: component)
  }
  
  override public func node(for context: ComponentContext) -> Node {
    let insets = state.insets
    let hInsets = insets.left + insets.right
    let vInsets = insets.top + insets.bottom
    
    var childSize = context.sizeRange
    childSize.min = childSize.min.inset(h: hInsets, v: vInsets)
    childSize.max = childSize.max.inset(h: hInsets, v: vInsets)
    
    var childContext = context
    childContext.sizeRange = childSize
    
    let childNode = state.component.node(for: childContext)
    let size = childNode.size.inset(h: -hInsets, v: -vInsets)
    
    var node = Node()
    node.size = size.constrained(by: context.sizeRange)
    node.subnodes = [Subnode(node: childNode,
                             at: CGPoint(x: insets.left, y: insets.top))]

    return node
  }
}
