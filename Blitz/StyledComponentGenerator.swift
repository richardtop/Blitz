import UIKit

class CoolComponent: ComponentBase {
  
  var component: Component!
  var color = UIColor.lightGray
  
  var expanded = false

  override init() {
    super.init()
    let component = generateComponent()
    component.parent = self
    self.component = component
  }
  
  override func node(for context: ComponentContext) -> Node {
    return component.node(for: context)
  }
  
  func yopta() {
    
  }
  
  override func didSelectComponents(components: [Component]) {
    component = generateComponent()
    component.parent = self
    reloadDelegate?.reload(component: self)
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
                                  for i in 0...2 {
                                   add(TextComponent(text: NSAttributedString(string: "Expanded Part of the text", style: textStyles.headingAccent)))
                                  }
                                }
      })
      
      let list = ListComponent(direction: .vertical,
                               horizontalAlignment: .left,
                               verticalAlignment: .top,
                               interItemSpace: 5,
                               components: [
//                                TapableComponent(component: TextComponent(text: NSAttributedString(string: "Titl", style: textStyles.title)),
//                                                 onSelectHandler: { (component) in
//                                                  print("Inner closure of tapable component")
//                                                  if let textComponent = component as? TextComponent {
//                                                    print(String(describing: textComponent.text))
//                                                  }
//                                }),
                                
                                
                                TapableComponent(TextComponent(text: NSAttributedString(string: "Prässä mær", style: textStyles.title))) {component in
                                  if let component = component as? TextComponent {
                                    self.expanded = !self.expanded
                                  }
                                },
                                
                                
                                TextComponent(text: NSAttributedString(string: "Title", style: textStyles.title)),
                                TextComponent(text: NSAttributedString(string: "Subtitle", style: textStyles.subtitle)),
                                TextComponent(text: NSAttributedString(string: "Heading1", style: textStyles.heading1)),
                                TextComponent(text: NSAttributedString(string: "Heading2", style: textStyles.heading2)),
                                TextComponent(text: NSAttributedString(string: "Heading3", style: textStyles.heading3)),
                                TextComponent(text: NSAttributedString(string: "HeadingAccent", style: textStyles.headingAccent)),
                                TextComponent(text: NSAttributedString(string: "Body", style: textStyles.body)),
                                TextComponent(text: NSAttributedString(string: StyledComponentGenerator.randomString(length: 100), style: textStyles.body)),
                                list2,
                                ])
      
      let listInset = InsetComponent(insets: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20),
                                     component: list)
      
      let background = BackgroundComponent(component: listInset) { (backgroundView) in
        backgroundView.backgroundColor = self.color
      }
      
      
      
      let inset = InsetComponent(insets: UIEdgeInsets(top: 20, left: 5, bottom: 20, right: 5),
                                 component: background)
      return inset
    })
    return futureComponent
  }
}

struct StyledComponentGenerator {
  static func randomString(length: Int) -> String {
    
    let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    let len = UInt32(letters.length)
    
    var randomString = ""
    
    for _ in 0 ..< length {
      let rand = arc4random_uniform(len)
      var nextChar = letters.character(at: Int(rand))
      randomString += NSString(characters: &nextChar, length: 1) as String
    }
    
    return randomString
  }
  
}
