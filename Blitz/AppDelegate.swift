 //
 //  AppDelegate.swift
 //  Blitz
 //
 //  Created by user on 15/10/2017.
 //  Copyright © 2017 user. All rights reserved.
 //
 
 import UIKit
 
 
 @UIApplicationMain
 class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  var logicControllerHolder: LogicController!
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.backgroundColor = UIColor.white
    window?.makeKeyAndVisible()
    
    
    let screen = UIScreen.main.bounds
    let maxSize = CGSize(width: screen.size.width,
                         height: .greatestFiniteMagnitude)
    let sizeRange = SizeRange(min: .zero, max: maxSize)
    let context = ComponentContext(sizeRange: sizeRange, styleSheet: StyleSheet())
    
    let logicController = LogicController(context: context,
                                          componentProvider: SimulationComponentProvider())
    window?.rootViewController = logicController.viewController
    logicController.viewController.reloadData()
    
    logicControllerHolder = logicController
    
    return true
  }
 }

 
