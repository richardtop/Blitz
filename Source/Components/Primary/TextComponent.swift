import UIKit

public class TextComponent: ComponentBase {
  let text: NSAttributedString?

  public init(text: NSAttributedString?) {
    self.text = text
  }
  
  override public func node(for context: ComponentContext) -> Node {
    var node = Node()
    node.state = text
    node.component = self
    node.viewType = TextCell.self
    
    let maxWidth = context.sizeRange.max.width
    let textSize = text?.boundingRect(with: CGSize(width: maxWidth, height: .greatestFiniteMagnitude),
                                  options: [.usesLineFragmentOrigin, .usesFontLeading],
                                  context: nil)
    let size = textSize?.size ?? .zero
    node.size = size.constrained(by: context.sizeRange)

    return node
  }
}

extension TextComponent {
  public convenience init(text: String?, style: TextStyleProtocol) {
    self.init(text: NSAttributedString(string: text ?? "", style: style))
  }
}
