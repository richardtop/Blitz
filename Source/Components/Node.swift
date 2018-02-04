import CoreGraphics

public protocol NodeUpdatable {
  func update(node: Node)
}

public struct Node {
  public var state: Any?
  public var component: Component?
  public var highlighted = false
  public var subnodes: [Subnode]
  public var size: CGSize
  public var zIndex: Int = 0
  public var uniqueId = UUID().hashValue
  public var translatesIntoView: Bool {
    return viewType != nil
  }
  public var viewType: NodeUpdatable.Type?

  init(subnodes: [Subnode] = [], size: CGSize = .zero) {
    self.subnodes = subnodes
    self.size = size
  }

  func recursiveDescription() {
    recursiveDescription(acc: "", origin: .zero)
  }
  
  func recursiveDescription(acc: String, origin: CGPoint) {
    print(acc + "Node: frame: \(origin.x), \(origin.y); \(size.width), \(size.height); z: \(zIndex)")
    subnodes.forEach{
      $0.recursiveDescription(acc: acc + "| ")
    }
  }
}

public struct Subnode {
  public var origin: CGPoint
  public var node: Node
  
  public init(node: Node, at point: CGPoint = .zero) {
    self.node = node
    self.origin = point
  }
  
  public func recursiveDescription() {
    recursiveDescription(acc: "")
  }
  
  public func recursiveDescription(acc: String) {
    node.recursiveDescription(acc: acc, origin: origin)
  }
}
