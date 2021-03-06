import CoreGraphics

public struct ListComponentState {
  public enum Direction {
    case horizontal
    case vertical
  }

  public enum HorizontalAlignment {
    case left
    case center
    case right
    case justified
  }

  public enum VerticalAlignment {
    case top
    case middle
    case bottom
    case justified
  }

  public var components: [Component]
  public var direction: Direction
  public var horizontalAlignment: HorizontalAlignment
  public var verticalAlignment: VerticalAlignment
  public var interItemSpace: CGFloat
  public var grow: Bool
}

open class ListComponent: ComponentBase {
  public typealias ComponentProvider = (Component) -> Void
  public typealias ListComponentAdder = (ComponentProvider) -> Void
  
  public let state: ListComponentState
  
  public init(state: ListComponentState) {
    self.state = state
  }
  
  public init(direction: ListComponentState.Direction = .vertical,
       horizontalAlignment: ListComponentState.HorizontalAlignment = .left,
       verticalAlignment: ListComponentState.VerticalAlignment = .bottom,
       interItemSpace: CGFloat = 0,
       grow: Bool = true,
       components: [Component]) {
    self.state = ListComponentState(components: components,
                                    direction: direction,
                                    horizontalAlignment: horizontalAlignment,
                                    verticalAlignment: verticalAlignment,
                                    interItemSpace: interItemSpace,
                                    grow: grow)
    super.init()
    
    setParentComponentFor(components: components)
  }
  
  public init(direction: ListComponentState.Direction = .horizontal,
       horizontalAlignment: ListComponentState.HorizontalAlignment = .left,
       verticalAlignment: ListComponentState.VerticalAlignment = .bottom,
       interItemSpace: CGFloat = 0,
       grow: Bool = true,
       addComponent: ListComponentAdder) {
    
    var components = [Component]()
    addComponent { (newComponent) in
      components.append(newComponent)
    }
    
    self.state = ListComponentState(components: components,
                                    direction: direction,
                                    horizontalAlignment: horizontalAlignment,
                                    verticalAlignment: verticalAlignment,
                                    interItemSpace: interItemSpace,
                                    grow: grow)
    super.init()
    
    setParentComponentFor(components: components)
  }
  
  private func setParentComponentFor(components: [Component]) {
    components.forEach { (component) in
      component.parent = self
    }
  }
  
  override open func node(for context: ComponentContext) -> Node {
    var node = Node()
    var listSize = CGSize.zero
    let componentSize = context.sizeRange
    var childMaxSize = componentSize.max
    let space = state.interItemSpace
    let direction = state.direction
    var subnodes = [Subnode]()
    
    let components = state.components
    
    loop: for component in components {
      switch direction {
      case .horizontal:
        if childMaxSize.width <= space {
          break loop
        }
      case .vertical:
        if childMaxSize.height <= space {
          break loop
        }
      }
      
      var childContext = context
      childContext.sizeRange = SizeRange(max: childMaxSize)
      
      let componentNode = component.node(for: childContext)
      
      switch direction {
      case .horizontal:
        childMaxSize.width -= space + componentNode.size.width
      case .vertical:
        childMaxSize.height -= space + componentNode.size.height
      }
      let subnode = Subnode(node: componentNode)
      subnodes.append(subnode)
    }
    
    var newSubnodes = [Subnode]()
    for subnode in subnodes {
      var subnode = subnode
      switch direction {
      case .horizontal:
        if listSize.width > 0 {
          listSize.width += space
        }
        subnode.origin = CGPoint(x: listSize.width, y: 0)
        newSubnodes.append(subnode)
        
        listSize.width += subnode.node.size.width
        listSize.height = max(subnode.node.size.height, listSize.height)
      case .vertical:
        if listSize.height > 0 {
          listSize.height += space
        }
        subnode.origin = CGPoint(x: 0, y: listSize.height)
        newSubnodes.append(subnode)
        
        listSize.width = max(subnode.node.size.width, listSize.width)
        listSize.height += subnode.node.size.height
      }
    }
    subnodes = newSubnodes
    
    var nodeSize = listSize.constrained(by: context.sizeRange)

    // TODO: Constrain MIN size as well
    if state.grow {
      switch direction {
      case .horizontal:
        nodeSize.height = context.sizeRange.max.height
        break
      case .vertical:
        nodeSize.width = context.sizeRange.max.width
        break
      }
    }

    let hAlign = state.horizontalAlignment
    let vAlign = state.verticalAlignment

    if hAlign == .justified {
      nodeSize.width = context.sizeRange.max.width
    }

    if vAlign == .justified {
      nodeSize.height = context.sizeRange.max.height
    }

    let dxTotal = nodeSize.width - listSize.width
    let dyTotal = nodeSize.height - listSize.height

    newSubnodes = []

    let subnodesCount = subnodes.count

    for (idx, subnode) in subnodes.enumerated() {
      var subnode = subnode
      var origin = subnode.origin
      let subnodeSize = subnode.node.size

      func justifiedOffset(totalSpace: CGFloat) -> CGFloat {
        return (totalSpace / CGFloat(max(subnodesCount - 1, 1)) * CGFloat(idx))
      }

      switch direction {
      case .horizontal:
        switch hAlign {
        case .left: break
        case .center: origin.x += dxTotal/2
        case .right: origin.x += dxTotal
        case .justified: origin.x += justifiedOffset(totalSpace: dxTotal)
        }

        let dy = nodeSize.height - subnodeSize.height
        switch vAlign {
        case .top: break
        case .middle: origin.y += dy/2
        case .bottom: origin.y += dy
        case .justified: origin.y += dy/2
        }
        
      case .vertical:
        let dx = nodeSize.width - subnodeSize.width
        switch hAlign {
        case .left: break
        case .center: origin.x += dx/2
        case .right: origin.x += dx
        case .justified: origin.x += dx/2
        }
        
        switch vAlign {
        case .top: break
        case .middle: origin.y += dyTotal/2
        case .bottom: origin.y += dyTotal
        case .justified: origin.y += justifiedOffset(totalSpace: dyTotal)
        }
      }
      subnode.origin = origin
      newSubnodes.append(subnode)
    }
    subnodes = newSubnodes
    
    node.subnodes = subnodes
    node.size = nodeSize
    
    return node
  }
}
