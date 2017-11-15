import UIKit

class SimulationComponentProvider: ComponentProvider {
  func components(offset: Int, count: Int, completion: @escaping (Result<[Component]>) -> Void) {
    SimulationComponentProvider.components(offset: offset, count: count) { (components) in
      completion(Result.Success(components))
    }
  }
  
  static func components(offset: Int, count: Int, completion: @escaping ([Component]) -> Void) {
    var components = [Component]()
    for i in 0...count {
//      let new = generateComponent(seed: i + offset)
      let new = generateCoolComponent()
      components.append(new)
    }

    DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 0.5) {
      completion(components)
    }

  }
  
  static func generateComponent(seed: Int = 0) -> Component {
    return FutureComponent(builder: { (context) -> Component in
      var component: Component = ListComponent(direction: .vertical,
                               horizontalAlignment: .center,
                               verticalAlignment: .bottom,
                               interItemSpace: 5,
                               addComponent: { (add) in
//                                add(TextComponent(text: NSAttributedString(string: "Test Component", style: context.styleSheet.text.title)))
                                add(TextComponent(text: NSAttributedString(string: "Number: \(seed)", style: context.styleSheet.text.body)))
      })

      component = BackgroundComponent(component: component, configurationBlock: { (backgroundView) in
        backgroundView.backgroundColor = .lightGray
      })
      
      component = InsetComponent(insets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10), component: component)
      
      return component
    })
  }
  
  
  static func generateCoolComponent() -> Component {
    return CoolComponent()
  }
}
