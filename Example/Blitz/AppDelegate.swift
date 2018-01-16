import UIKit
import Blitz
 
 @UIApplicationMain
 class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.backgroundColor = UIColor.white
    window?.makeKeyAndVisible()

    let host = HostController()


    var largeAmountofComponents = [Component]()

    for i in 0...100 {
      largeAmountofComponents.append(CoolComponent(idx: i))
    }

    let component = CoolComponent()
    host.appendNewComponents(components: largeAmountofComponents)
    window?.rootViewController = host

    
    return true
  }
 }
