import UIKit
import Blitz
 
 @UIApplicationMain
 class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.backgroundColor = UIColor.white
    window?.makeKeyAndVisible()

    var host = MCollectionController()
//    let host = HostController()


    var largeAmountofComponents = [Component]()

    for i in 0...100 {
      largeAmountofComponents.append(CoolComponent(idx: i))
    }


    host.appendNewComponents(components: largeAmountofComponents)

    let navigation = UINavigationController(rootViewController: host)

    window?.rootViewController = navigation
    return true
  }
 }
