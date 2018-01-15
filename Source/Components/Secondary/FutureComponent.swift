import Foundation

open class FutureComponent: ComponentBase {
  public typealias FutureComponentBuilder = (ComponentContext) -> Component
  
  public let builder: FutureComponentBuilder
  public var cachedComponent: Component?
  
  public init(builder: @escaping FutureComponentBuilder) {
    self.builder = builder
  }
  
  open func component(for context: ComponentContext) -> Component {
    let component = builder(context)
    cachedComponent = component
    component.parent = self
    return component
  }

  override open func node(for context: ComponentContext) -> Node {
    let childComponent = component(for: context)
    return childComponent.node(for: context)
  }
}
