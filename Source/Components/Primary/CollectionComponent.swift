import UIKit

public struct CollectionComponentState {
  var backgroundColor: UIColor?
  var components = [Component]()
  var size = CGSize(width: 1000, height: 100)
  var driver: CollectionDriver = CollectionDriver()
  public init(components: [Component] = []) {}
}

open class CollectionComponent: ComponentBase {
  public var state: CollectionComponentState

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
