import UIKit

public struct StackComponentState {
  public enum Direction {
    case horizontal
    case vertical
  }
  //  public var direction: Direction
  public var components: [Component]
}

public class StackComponent: ComponentBase {
  let state: StackComponentState

  public init(state: StackComponentState) {
    self.state = state
    super.init()
  }

  public init(components: [Component]) {
    self.state = StackComponentState(components: components)
    super.init()
  }

  public override func node(for context: ComponentContext) -> Node {
    var nodes = [Node]()
    for component in state.components {
      let n = component.node(for: context)
      nodes.append(n)
    }

    var width: CGFloat = 0
    var height: CGFloat = 0

    for n in nodes {
      width += n.size.width
      height = max(height, n.size.height)
    }

    let nodeSize = CGSize(width: context.sizeRange.max.width,
                          height: height)

    let spacing = (nodeSize.width - width) / CGFloat(nodes.count - 1)

    var origin = CGPoint.zero
    var subnodes = [Subnode]()
    for n in nodes {
      let subnode = Subnode(node: n,
                            at: origin)
      subnodes.append(subnode)
      origin.x += n.size.width + spacing
    }

    var node = Node()
    node.size = nodeSize
    node.subnodes = subnodes

    return node
  }
}
