//
//  HostController.swift
//  Pods
//
//  Created by Richard on 16/01/2018.
//

import UIKit

open class HostController: UIViewController {

  var host = CollectionViewCell()
  var driver = CollectionDriver()

  var context: ComponentContext!

  open override func loadView() {
    self.view = host
  }

  public init() {
    super.init(nibName: nil, bundle: nil)
    updateContext()
    host.driver = driver
    host.attach(driver: driver)
  }

  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  open func appendNewComponents(components: [Component]) {
    driver.appendNewComponents(components: components)
  }

  open func replace(components: [Component]) {
    driver.replace(components: components)
    host.collectionView.reloadData()
  }

  func updateContext() {
    let screen = UIScreen.main.bounds
    let maxSize = CGSize(width: screen.size.width,
                         height: .greatestFiniteMagnitude)
    reloadDriverWithSize(size: maxSize)
  }

  func reloadDriverWithSize(size: CGSize) {
    // TODO:  Check for horizontally scrollabe container
    let maxSize = CGSize(width: size.width,
                         height: .greatestFiniteMagnitude)
    let sizeRange = SizeRange(min: .zero, max: maxSize)
    // TODO: Copy context and replace only size
    self.context = ComponentContext(sizeRange: sizeRange, styleSheet: StyleSheet())
    self.driver.context = self.context
    // TODO: Switch to background thread to recalculate layout ???
    self.driver.recalculateLayout()
    self.host.collectionView.reloadData()
  }

  open override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    DispatchQueue.global(qos: .userInitiated).async {

      let maxSize = CGSize(width: size.width,
                           height: .greatestFiniteMagnitude)
      let sizeRange = SizeRange(min: .zero, max: maxSize)
      self.context = ComponentContext(sizeRange: sizeRange, styleSheet: StyleSheet())
      self.driver.context = self.context
      self.driver.recalculateLayout()
      // TODO: Add "quick reload" algorithm to reload visible items immediately and then proceed with the rest
      // TODO: Add speculative layout: calculate both H and V layouts and pick one when needed.
      DispatchQueue.main.async {
        self.host.collectionView.reloadData()
        self.host.collectionView.invalidateIntrinsicContentSize()
        self.host.collectionView.collectionViewLayout.invalidateLayout()
      }
    }
  }
}
