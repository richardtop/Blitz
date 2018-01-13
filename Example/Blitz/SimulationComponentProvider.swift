import UIKit
import Blitz

public class SimulationComponentProvider: ComponentProvider {
  public func components(offset: Int, count: Int, completion: @escaping (Result<[Component]>) -> Void) {
    SimulationComponentProvider.components(offset: offset, count: count) { (components) in
      completion(Result.Success(components))
    }
  }
  
  static func components(offset: Int, count: Int, completion: @escaping ([Component]) -> Void) {
    var components = [Component]()
    for i in 0...3 {
//      let new = generateCollectionComponent()
//      let new = generateTextComponent()
      let new = generateCoolComponent()
      components.append(new)
    }

    DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 0.5) {
      completion(components)
    }
  }

  static func generateTextComponent() -> Component {
    return FutureComponent(builder: { (context) -> Component in
      return ListComponent(direction: .vertical,
                                horizontalAlignment: .left,
                                verticalAlignment: .top,
                                interItemSpace: 5,
                                grow: false,
                                addComponent: { (add) in
                                    for i in 0...2 {
                                      add(TextComponent(text: "Expanded Part of the text", style: context.styleSheet.text.title1))
                                  }
      })
    })
  }

  static func generateCoolComponent() -> Component {
    return CoolComponent()
  }

  static func generateCollectionComponent() -> Component {
    let future = FutureComponent { (context) -> Component in
      let style = context.styleSheet.text
      let text = TextComponent(text: "Morgan Stanley", style: style.title1)
      return CollectionComponent(components: [text, generateCoolComponent()])
    }
    return future
  }
}
