import UIKit

public struct CollectionComponentState {
  public enum Direction {
    case horizontal
    case vertical
  }
  public var direction: Direction = .vertical
  public var components = [Component]()
  public var preferredSize = CGSize.maxSize
  // Do not store driver here to prevent memory leaks
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
  }

  public init(components: [Component] = []) {
    self.state = CollectionComponentState(components: components)
    super.init()
    state.driver.components = components
  }

  override open func node(for context: ComponentContext) -> Node {
    var node = Node()

    // Inject correct infinite width or height depending on scroll direction
    var childContext = context
    childContext.sizeRange.max = state.preferredSize
    state.driver.components = state.components
    state.driver.context = childContext

    // Could there be a better place to reload driver to save perormance?
    state.driver.update(direction: state.direction)

    let contentsize = state.driver.internalSize()

    node.component = self
    node.state = state

    node.size = contentsize.constrained(by: context.sizeRange)
    node.viewType = CollectionViewCell.self

    return node
  }
}
