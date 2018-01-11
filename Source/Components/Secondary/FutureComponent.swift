import Foundation

public class FutureComponent: ComponentBase {
  public typealias FutureComponentBuilder = (ComponentContext) -> Component
  
  let builder: FutureComponentBuilder
  var cachedComponent: Component?
  
  public init(builder: @escaping FutureComponentBuilder) {
    self.builder = builder
  }
  
  func component(for context: ComponentContext) -> Component {
    let component = builder(context)
    cachedComponent = component
    component.parent = self
    return component
  }

  override public func node(for context: ComponentContext) -> Node {
    let childComponent = component(for: context)
    return childComponent.node(for: context)
  }
}
