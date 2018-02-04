import UIKit

public class BackingController: UIViewController {

  var components = [Component]()
  var pool = ReusePool()
  var dataSource = BackingDataSource()
  var scrollView: BackingView!

  public override func loadView() {
    self.scrollView = BackingView()
    self.view = self.scrollView
  }

  public override func viewDidLoad() {
    super.viewDidLoad()
    fixContext()
  }

  func fixContext() {
    let screen = UIScreen.main.bounds
    let size = CGSize(width: screen.size.width,
                      height: .greatestFiniteMagnitude)
    // TODO:  Check for horizontally scrollabe container
    let maxSize = CGSize(width: size.width,
                         height: .greatestFiniteMagnitude)
    let sizeRange = SizeRange(min: .zero, max: maxSize)
    // TODO: Copy context and replace only size
    scrollView.context = ComponentContext(sizeRange: sizeRange, styleSheet: StyleSheet())
  }

  open func appendNewComponents(components: [Component]) {
    scrollView.appendNewComponents(components: components)
  }
}
