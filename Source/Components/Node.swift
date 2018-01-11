import CoreGraphics

protocol NodeUpdatable {
  func update(node: Node)
}

public struct Node {
  var state: Any?
  var component: Component?
  var highlighted = false
  var subnodes: [Subnode]
  var size: CGSize
  var zIndex: Int = 0
  var translatesIntoView = false
  var viewType: NodeUpdatable.Type?

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
  var origin: CGPoint
  var node: Node
  
  init(node: Node, at point: CGPoint = .zero) {
    self.node = node
    self.origin = point
  }
  
  func recursiveDescription() {
    recursiveDescription(acc: "")
  }
  
  func recursiveDescription(acc: String) {
    node.recursiveDescription(acc: acc, origin: origin)
  }
}
