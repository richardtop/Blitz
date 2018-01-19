import UIKit

public class ProgressComponent: ComponentBase {
  public var state: Float?

  public init(progress: Float?) {
    self.state = progress
  }
  open override func node(for context: ComponentContext) -> Node {
    var node = Node()
    node.state = state
    node.component = self
    node.viewType = ProgressCell.self

    // Allow custom height in the future
    print(context.sizeRange.max.width)
    let size = CGSize(width: context.sizeRange.max.width, height: 2)
    node.size = size.constrained(by: context.sizeRange)
    return node
  }
}
