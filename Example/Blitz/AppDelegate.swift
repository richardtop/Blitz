import UIKit
import Blitz

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?

  fileprivate func showScrollViewBacked() {
    let host = BackingController()
    var largeAmountofComponents = [Component]()
    for i in 0...100 {
      largeAmountofComponents.append(CoolComponent())
    }
    window?.rootViewController = host
    host.appendNewComponents(components: largeAmountofComponents)
  }

  fileprivate func showCollectionViewbacked() {
    let host = HostController()
    var largeAmountofComponents = [Component]()

    for i in 0...100 {
      largeAmountofComponents.append(CoolComponent(idx: i))
    }
    window?.rootViewController = host
    host.appendNewComponents(components: largeAmountofComponents)
  }

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

    window = UIWindow(frame: UIScreen.main.bounds)
    window?.backgroundColor = UIColor.white
    window?.makeKeyAndVisible()

    showScrollViewBacked()
//    showCollectionViewbacked()


    return true
  }
}
