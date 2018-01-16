import UIKit

public struct CollectionComponentState {
  public enum Direction {
    case horizontal
    case vertical
  }
  public var direction: Direction = .vertical
  public var components = [Component]()
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

    switch state.direction {
    case .horizontal:
      childContext.sizeRange.max.width = .greatestFiniteMagnitude
//      childContext.sizeRange.max.height = state.size.height
    case .vertical:
//      childContext.sizeRange.max.width = state.size.width
      childContext.sizeRange.max.height = .greatestFiniteMagnitude
    }

    state.driver.components = state.components
    state.driver.context = childContext

    // Could there be a better place to reload driver to save perormance?
    state.driver.reloadDriver()

    let contentsize = state.driver.internalSize()

    node.component = self
    node.state = state
    node.size = contentsize.constrained(by: context.sizeRange)
    node.viewType = CollectionViewCell.self

    return node
  }
}
