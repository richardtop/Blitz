import CoreGraphics

public enum ListDirection {
  case horizontal
  case vertical
}

public enum ListHorizontalAlignment {
  case left
  case center
  case right
}

public enum ListVerticalAlignment {
  case top
  case middle
  case bottom
}

public struct ListComponentState {
  public var components: [Component]
  public var direction: ListDirection
  public var horizontalAlignment: ListHorizontalAlignment
  public var verticalAlignment: ListVerticalAlignment
  public var interItemSpace: CGFloat
}

open class ListComponent: ComponentBase {
  public typealias ComponentProvider = (Component) -> Void
  public typealias ListComponentAdder = (ComponentProvider) -> Void
  
  public let state: ListComponentState
  
  public init(state: ListComponentState) {
    self.state = state
  }
  
  public init(direction: ListDirection = .vertical,
       horizontalAlignment: ListHorizontalAlignment = .left,
       verticalAlignment: ListVerticalAlignment = .bottom,
       interItemSpace: CGFloat = 0,
       components: [Component]) {
    self.state = ListComponentState(components: components,
                                    direction: direction,
                                    horizontalAlignment: horizontalAlignment,
                                    verticalAlignment: verticalAlignment,
                                    interItemSpace: interItemSpace)
    super.init()
    
    setParentComponentFor(components: components)
  }
  
  public init(direction: ListDirection = .horizontal,
       horizontalAlignment: ListHorizontalAlignment = .left,
       verticalAlignment: ListVerticalAlignment = .bottom,
       interItemSpace: CGFloat = 0,
       addComponent: ListComponentAdder) {
    
    var components = [Component]()
    addComponent { (newComponent) in
      components.append(newComponent)
    }
    
    self.state = ListComponentState(components: components,
                                    direction: direction,
                                    horizontalAlignment: horizontalAlignment,
                                    verticalAlignment: verticalAlignment,
                                    interItemSpace: interItemSpace)
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
    
    let nodeSize = listSize.constrained(by: context.sizeRange)
    let dxTotal = nodeSize.width - listSize.width
    let dyTotal = nodeSize.height - listSize.height
    
    let hAlign = state.horizontalAlignment
    let vAlign = state.verticalAlignment
    
    newSubnodes = []
    
    for subnode in subnodes {
      var subnode = subnode
      var origin = subnode.origin
      let subnodeSize = subnode.node.size
      
      switch direction {
      case .horizontal:
        
        switch hAlign {
        case .left: break
        case .center: origin.x += dxTotal/2
        case .right: origin.x += dxTotal
        }
        
        let dy = nodeSize.height - subnodeSize.height
        switch vAlign {
        case .top: break
        case .middle: origin.y += dy/2
        case .bottom: origin.y += dy
        }
        
      case .vertical:
        let dx = nodeSize.width - subnodeSize.width
        switch hAlign {
        case .left: break
        case .center: origin.x += dx/2
        case .right: origin.x += dx
        }
        
        switch vAlign {
        case .top: break
        case .middle: origin.y += dyTotal/2
        case .bottom: origin.y += dyTotal
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
