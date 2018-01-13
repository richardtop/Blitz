import UIKit
import Blitz

open class CoolComponent: ComponentBase {
  
  var component: Component!
  var color = UIColor.white

  var expanded = false

  override init() {
    super.init()
    let component = generateComponent()
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

  func generateComponent() -> Component {
    let futureComponent = FutureComponent(builder: { (context) -> Component in
      let textStyles = context.styleSheet.text

      let list2 = ListComponent(direction: .vertical,
                                horizontalAlignment: .left,
                                verticalAlignment: .top,
                                interItemSpace: 5,
                                addComponent: { (add) in
                                  if self.expanded {
                                    //                                    for i in 0...2 {
                                    //                                      add(TextComponent(text: "Expanded Part of the text", style: textStyles.title1))
                                    //                                    }
                                  }
      })

      let button = TapableComponent(TextComponent(text: self.expanded ? "Collapse" : "Expand", style: textStyles.title1), { (component) in
        self.expanded = !self.expanded
          self.reloadDelegate?.reload(component: self)
      })

      let list = ListComponent(direction: .vertical,
                               horizontalAlignment: !self.expanded ? .left : .right,
                               verticalAlignment: .top,
                               interItemSpace: 5,
                               components: [
                                button,
                                TextComponent(text: "Title1", style: textStyles.title1),
                                TextComponent(text: "Title2", style: textStyles.title2),
                                TextComponent(text: "Title3", style: textStyles.title3),
                                TextComponent(text: "Headline", style: textStyles.headline),
                                TextComponent(text: "Body", style: textStyles.body),
                                TextComponent(text: "Callout", style: textStyles.callout),
                                TextComponent(text: "Subheadline", style: textStyles.subhead),
                                TextComponent(text: "Footnote", style: textStyles.footnote),
                                TextComponent(text: "Caption1", style: textStyles.caption1),
                                TextComponent(text: "Caption2", style: textStyles.caption2),
                                list2,
                                ])

      let listInset = InsetComponent(insets: UIEdgeInsets(top: 20, left: 20, bottom: self.expanded ? 80 : 20, right: 20),
                                     component: list)

      let background = BackgroundComponent(component: listInset) { (backgroundView) in
        backgroundView.backgroundColor = self.color

        let shadowPath = UIBezierPath(rect: backgroundView.bounds)
        backgroundView.layer.masksToBounds = false
        backgroundView.layer.shadowColor = UIColor.black.cgColor
        backgroundView.layer.shadowOffset = CGSize(width: 0, height: 0.5)
        backgroundView.layer.shadowOpacity = 0.2
        backgroundView.layer.shadowPath = shadowPath.cgPath
        backgroundView.layer.cornerRadius = 10
        backgroundView.layer.borderColor = UIColor.red.cgColor
        backgroundView.layer.borderWidth = 2
      }

      let list3 = ListComponent(direction: .vertical,
                                horizontalAlignment: .left,
                                verticalAlignment: .top,
                                interItemSpace: 5,
                                components: [
                                  InsetComponent(insets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0), component: TextComponent(text: "Section Header", style: textStyles.title2)),
                                  background
        ])

      let inset = InsetComponent(insets: UIEdgeInsets(top: 20 , left: 5, bottom: 10, right: 5),
                                 component: list3)
      return inset
    })
    return futureComponent
  }

}

