import UIKit

public class BackingController: UIViewController, UIScrollViewDelegate {

  var components = [Component]()
  var pool = ReusePool()
  var context: ComponentContext!
  var dataSource = BackingDataSource()
  var scrollView: UIScrollView!

  public override func loadView() {
    self.scrollView = UIScrollView()
    scrollView.bounces = true
    scrollView.alwaysBounceVertical = true
    self.view = self.scrollView
  }

  public override func viewDidLoad() {
    super.viewDidLoad()
    fixContext()
    scrollView.delegate = self
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
    self.context = ComponentContext(sizeRange: sizeRange, styleSheet: StyleSheet())
  }

  func reloadData() {
    for s in 0...dataSource.numberOfSections() - 1 {
      for i in 0...dataSource.numberOfItems(in: s) - 1 {
        let indexPath = IndexPath(indexes: [s, i])
        let node = dataSource.subnodeAtIndexPath(indexPath: indexPath)
        let viewType = node.node.viewType!
        let subview = pool.dequeue(type: viewType as! UIView.Type)
        if subview.superview == nil {
          view.addSubview(subview)
        }
        if let v = subview as? NodeUpdatable {
          v.update(node: node.node)
        }
        let frame = CGRect(origin: node.origin, size: node.node.size)
        subview.frame = frame
        subview.layer.zPosition = CGFloat(node.node.zIndex)
        subview.layer.borderColor = UIColor.red.cgColor
        subview.layer.borderWidth = 2
      }
    }
  }

  public func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let n = Int(scrollView.contentOffset.y)
    if n % 10 == 0 {
    let visibleRect = CGRect(origin: scrollView.contentOffset,
                             size: scrollView.bounds.size)

    let safeRect = visibleRect.insetBy(dx: -400, dy: -400)
    let toRemove = scrollView.subviews.filter{!$0.frame.intersects(safeRect)}
    pool.enqueue(views: toRemove)
    let sn = dataSource.subnodes(in: safeRect)
    displaySubnodes(sn ?? [])
    }
  }

  func displaySubnodes(_ subnodes: [Subnode]) {
    for node in subnodes {
      let viewType = node.node.viewType!
      let subview = pool.dequeue(type: viewType as! UIView.Type)
      if subview.superview == nil {
        view.addSubview(subview)
      }
      if let v = subview as? NodeUpdatable {
        v.update(node: node.node)
      }
      let frame = CGRect(origin: node.origin, size: node.node.size)
      subview.frame = frame
      subview.layer.zPosition = CGFloat(node.node.zIndex)
      subview.layer.borderColor = UIColor.red.cgColor
      subview.layer.borderWidth = 2
    }
  }



  open func appendNewComponents(components: [Component]) {
    let nodes = processNew(components: components)
    self.components.append(contentsOf: components)
    self.dataSource.append(sections: nodes)
    // TODO: recalculate what's needed only
    self.dataSource.prepare()
    scrollView.contentSize = dataSource.collectionViewContentSize
//    reloadData()
  }

  open func replace(components: [Component]) {
    let nodes = processNew(components: components)
    self.components = components
    self.dataSource.data = nodes
  }

  func processNew(components: [Component]) -> [[Subnode]] {
    var nodes = [[Subnode]]()
    for component in components {
      //      component.reloadDelegate = self
      let node = self.subnodes(component: component)
      nodes.append(node)
    }
    return nodes
  }

  open func subnodes(component: Component) -> [Subnode] {
    let subnodes = NodeTools.simplifiedNodeHierarchy(node: component.node(for: context), at: .zero, zIndex: 0)
    return subnodes
  }
}
