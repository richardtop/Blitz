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
    for i in 0...count {
      let new = generateCoolComponent()
      components.append(new)
    }

    DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 0.5) {
      completion(components)
    }
  }

  static func generateCoolComponent() -> Component {
    return CoolComponent()
  }
}
