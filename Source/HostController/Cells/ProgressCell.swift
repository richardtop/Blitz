import UIKit

open class ProgressCell: CollectionCellBase<UIProgressView>, NodeUpdatable {
  open func update(node: Node) {
    if let state = node.state as? Float? {
      view.progress = state ?? 0
    }
  }
}
