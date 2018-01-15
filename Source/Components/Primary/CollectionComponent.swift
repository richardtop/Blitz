import UIKit

public struct CollectionComponentState {
  public enum Direction {
    case horizontal
    case vertical
  }
  public var direction: Direction = .vertical
  public var backgroundColor: UIColor?
  public var components = [Component]()
  public var size = CGSize(width: 1000, height: 400)
  public var driver: CollectionDriver = CollectionDriver()
  public init(components: [Component] = []) {}
}

open class CollectionComponent: ComponentBase {
  public var state: CollectionComponentState

  public init(direction: CollectionComponentState.Direction = .vertical) {
    var state = CollectionComponentState()
    state.direction = direction
    self.state = state
  }

  public init(state: CollectionComponentState) {
    self.state = state
    super.init()
    self.state.backgroundColor = .random
  }

  public init(components: [Component] = []) {
    self.state = CollectionComponentState(components: components)
    super.init()
    self.state.backgroundColor = .random
    state.driver.components = components
  }

  override open func node(for context: ComponentContext) -> Node {
    var node = Node()


    var childContext = context
    childContext.sizeRange.max.height = state.size.height
    state.driver.context = childContext
    state.driver.reloadDriver()

    node.component = self
    node.state = state
    node.size = state.size.constrained(by: context.sizeRange)
    node.viewType = CollectionViewCell.self

    return node
  }
}

extension CGFloat {
  static var random: CGFloat {
    return CGFloat(arc4random()) / CGFloat(UInt32.max)
  }
}

extension UIColor {
  static var random: UIColor {
    return UIColor(red: .random, green: .random, blue: .random, alpha: 1.0)
  }
}
