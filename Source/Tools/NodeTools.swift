import CoreGraphics

struct NodeTools {
  static func simplifiedNodeHierarchy(node: Node, at point: CGPoint, zIndex: Int) -> [Subnode] {
    var acc = [Subnode]()
    NodeTools.simplifyNodeHierarchy(node: node, at: point, zIndex: zIndex, acc: &acc)
    return acc
  }
  
  static func simplifyNodeHierarchy(node: Node, at point: CGPoint, zIndex: Int, acc: inout [Subnode]) {
    var node = node
    if !node.translatesIntoView {
      for subnode in node.subnodes {
        simplifyNodeHierarchy(node: subnode.node, at: point + subnode.origin, zIndex: zIndex, acc: &acc)
      }
    } else {
      if !node.subnodes.isEmpty {
        for subnode in node.subnodes {
          simplifyNodeHierarchy(node: subnode.node, at: point + subnode.origin, zIndex: zIndex + 1, acc: &acc)
        }
        node.subnodes = []
      }
      node.zIndex = zIndex
      node.size = ceil(node.size)
      acc.append(Subnode(node: node, at: ceil(point)))
    }
  }
}
