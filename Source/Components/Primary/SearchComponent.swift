import UIKit

public class SearchComponent: ComponentBase {
  open override func node(for context: ComponentContext) -> Node {
    var node = Node()
//    node.state = ...
    node.component = self
    node.viewType = SearchCell.self

    let size = CGSize(width: context.sizeRange.max.width, height: 44)
    node.size = size.constrained(by: context.sizeRange)
    return node
  }
}
