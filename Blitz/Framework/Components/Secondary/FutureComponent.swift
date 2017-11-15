import Foundation

class FutureComponent: ComponentBase {
  typealias FutureComponentBuilder = (ComponentContext) -> Component
  
  let builder: FutureComponentBuilder
  var cachedComponent: Component?
  
  init(builder: @escaping FutureComponentBuilder) {
    self.builder = builder
  }
  
  func component(for context: ComponentContext) -> Component {
    let component = builder(context)
    cachedComponent = component
    component.parent = self
    return component
  }

  override func node(for context: ComponentContext) -> Node {
    let childComponent = component(for: context)
    return childComponent.node(for: context)
  }
}
