import UIKit

public struct SeparatorComponentState {
  public enum Direction {
    case horizontal
    case vertical
  }
  public let direction: Direction
  public let color: UIColor
  public let thickness: CGFloat
}

// Better take separator out of TableView?
open class SeparatorComponent: ComponentBase {
  public var state: SeparatorComponentState

  public init(state: SeparatorComponentState) {
    self.state = state
    super.init()
  }

  public convenience init(direction: SeparatorComponentState.Direction = .horizontal, color: UIColor = .lightGray, thickness: CGFloat = 1) {
    self.init(state: SeparatorComponentState(direction: direction, color: color, thickness: thickness))
  }

  override open func node(for context: ComponentContext) -> Node {
    var node = Node()
    node.component = self

    var size = CGSize.zero
    switch self.state.direction {
    case .horizontal:
      size.width = .greatestFiniteMagnitude
      size.height = self.state.thickness
    case .vertical:
      size.width = self.state.thickness
      size.height = .greatestFiniteMagnitude
    }
      node.size = size.constrained(by: context.sizeRange)

    
    node.viewType = ViewCell.self
    
    let updateBlock:  ((UIView) -> Void) = { separator in
      separator.backgroundColor = self.state.color
    }
    node.state = updateBlock

    return node
  }
}
