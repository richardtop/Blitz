import UIKit

class ReusePool {
  var storage: [String: [UIView]] = [:]

  init() {

  }

  func enqueue(view: UIView) {
    view.tag = 0
    let key = String(describing: type(of: view))
    var array: [UIView]! = storage[key]
    if array == nil {
      array = []
      storage[key] = array
    }

    storage[key]?.append(view)
  }

  func enqueue(views: [UIView]) {
    views.forEach(self.enqueue)
  }

  func dequeue<T: UIView>() -> T {
    let key = String(describing: T.self)
    guard var array = storage[key] else {return T()}
    guard !array.isEmpty else {return T()}
    print("actually dequeuing")
    return array.removeLast() as! T
  }

  func dequeue(type: UIView.Type) -> UIView {
    let key = String(describing: type)
    guard var array = storage[key] else {return type.init()}
    guard !array.isEmpty else {return type.init()}
    return array.removeLast()
  }
}
