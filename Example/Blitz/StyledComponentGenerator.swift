import UIKit
import Blitz

extension String {

  static func random(length: Int = 20) -> String {
    let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    var randomString: String = ""

    for _ in 0..<length {
      let randomValue = arc4random_uniform(UInt32(base.count))
      randomString += "\(base[base.index(base.startIndex, offsetBy: Int(randomValue))])"
    }
    return randomString
  }
}

open class CoolComponent: ComponentBase {

  var component: Component!
  var color = UIColor.white

  var expanded = false

  init(idx: Int = -1) {
    super.init()
    let component = generateComponent(idx: idx)
    component.parent = self
    self.component = component
  }

  override open func node(for context: ComponentContext) -> Node {
    return component.node(for: context)
  }

  override open func didSelectComponents(components: [Component]) {
    component = generateComponent()
    component.parent = self
    //    reloadDelegate?.reload(component: self)
  }

  func generateComponent(idx: Int = -1) -> Component {
    let futureComponent = FutureComponent(builder: { (context) -> Component in
      let textStyles = context.styleSheet.text

      let list2 = ListComponent(direction: .vertical,
                                horizontalAlignment: .left,
                                verticalAlignment: .top,
                                interItemSpace: 5,
                                grow: true,
                                addComponent: { (add) in
                                  if self.expanded {
                                    for i in 0...2 {
                                      add(TextComponent(text: "Expanded Part of the text", style: textStyles.title1))
                                    }
                                  }
      })

      let button = TapableComponent(TextComponent(text: self.expanded ? "Collapse" : "Expand", style: textStyles.title1), { (component) in
        //        self.expanded = !self.expanded
        self.reloadDelegate?.reload(component: self)
      })



      let embeddedlist = ListComponent(direction: .vertical,
                                        horizontalAlignment: .left,
                                        verticalAlignment: .bottom,
                                        interItemSpace: 5,
                                        grow: false,
                                        components: [
                                          TextComponent(text: "Title1", style: textStyles.title1),
                                          TextComponent(text: "Title2", style: textStyles.title2),
                                          TextComponent(text: "Title2", style: textStyles.title2),
                                          TextComponent(text: "Title2", style: textStyles.title2),
                                          TextComponent(text: "Title2", style: textStyles.title2),
        ])

      var embeddedArray = [Component]()

      for i in 0...5 {
        embeddedArray.append(embeddedlist)
      }

      let collection = CollectionComponent(direction: .horizontal)
      collection.state.components = embeddedArray

      let list = ListComponent(direction: .vertical,
                               horizontalAlignment: !self.expanded ? .left : .right,
                               verticalAlignment: .top,
                               interItemSpace: 5,
                               grow: false,
                               components: [
                                button,
                                list2,
                                TextComponent(text: "Title1" + String.random(length: 10), style: textStyles.title1),
                                TextComponent(text: "Title2" + String.random(length: 10), style: textStyles.title2),
                                TextComponent(text: "Title3" + String.random(length: 10), style: textStyles.title3),
//                                TextComponent(text: "Headline + String.random(length: 10)", style: textStyles.headline),
//                                TextComponent(text: "Body" + String.random(length: 10), style: textStyles.body),
//                                TextComponent(text: "Callout" + String.random(length: 10), style: textStyles.callout),
//                                TextComponent(text: "Subheadline" + String.random(length: 10), style: textStyles.subhead),
//                                TextComponent(text: "Footnote" + String.random(length: 10), style: textStyles.footnote),
//                                TextComponent(text: "Caption1" + String.random(length: 10), style: textStyles.caption1),
//                                TextComponent(text: "Caption2" + String.random(length: 10), style: textStyles.caption2),
                                list2,
                                collection
        ])

      let listInset = InsetComponent(insets: UIEdgeInsets(top: 10, left: 10, bottom: self.expanded ? 80 : 20, right: 20),
                                     component: list)

      let background = BackgroundComponent(component: listInset) { (backgroundView) in
        backgroundView.backgroundColor = self.color


        let layer = backgroundView.layer
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 2, height: 4)
        layer.shadowRadius = 8
        layer.shadowOpacity = 0.2
        layer.shadowPath = UIBezierPath(roundedRect: backgroundView.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 8, height: 8)).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        backgroundView.layer.cornerRadius = 10
//        backgroundView.layer.borderColor = UIColor.red.cgColor
//        backgroundView.layer.borderWidth = 2
      }

      let list3 = ListComponent(direction: .vertical,
                                horizontalAlignment: .left,
                                verticalAlignment: .top,
                                interItemSpace: 5,
                                grow: false,
                                components: [
                                  InsetComponent(insets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0), component: TextComponent(text: "Section Header + \(idx)", style: textStyles.title2)),
                                  background
        ])

      let inset = InsetComponent(insets: UIEdgeInsets(top: 20 , left: 10, bottom: 10, right: 10),
                                 component: list3)

      return inset
    })
    return futureComponent
  }

}

