//
//  MCollectionController.swift
//  Blitz
//
//  Created by Richard on 22/01/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import Blitz

class MCollectionController: UICollectionViewController {


  public weak var displayDelegate: CollectionViewCellDisplayDelegate?

  var driver = CollectionDriver()
  var context: ComponentContext!

  public var dataSource: NodeCollectionViewDataSource? {
    return collectionView?.dataSource as? NodeCollectionViewDataSource
  }

  init() {
    let layout = CollectionViewLayout(direction: .vertical)
    super.init(collectionViewLayout: layout)

    updateContext()
    attach(driver: driver)
    let collectionView = self.collectionView!
    collectionView.showsHorizontalScrollIndicator = false
    collectionView.bounces = true
    collectionView.alwaysBounceVertical = true
    collectionView.delegate = self
    collectionView.backgroundColor = .white



    useLayoutToLayoutNavigationTransitions = false

    registerCells()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  open func registerCells() {
    collectionView?.registerClasses([ImageCell.self,
                                     ViewCell.self,
                                     TextCell.self,
                                     SearchCell.self,
                                     ProgressCell.self,
                                     CollectionViewCell.self])
  }

  open func appendNewComponents(components: [Component]) {
    driver.appendNewComponents(components: components)
    self.driver.recalculateLayout()
    collectionView?.reloadData()
  }

  open func replace(components: [Component]) {
    driver.replace(components: components)
    collectionView?.reloadData()
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
    self.collectionView?.reloadData()
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
        self.collectionView?.reloadData()
        self.collectionView?.invalidateIntrinsicContentSize()
        self.collectionView?.collectionViewLayout.invalidateLayout()
      }
    }
  }


  open func update(node: Node) {
    if let state = node.state as? CollectionComponentState {
      let driver = state.driver
      attach(driver: driver)
      collectionView!.reloadData()
    }
  }

  open func attach(driver: CollectionDriver) {
    let dataSource = driver.dataSource
    collectionView!.dataSource = dataSource
    (collectionView!.collectionViewLayout as! CollectionViewLayout).dataSource = dataSource
  }


  open func reloadData() {
    collectionView!.reloadData()
  }

  open func reloadItems(at indexPaths: [IndexPath], animated: Bool = true) {
    if !animated {
      UIView.performWithoutAnimation {
        self.collectionView!.reloadItems(at: indexPaths)
      }
    } else {
      self.collectionView!.reloadItems(at: indexPaths)
    }
  }

  open func reloadSection(sections: IndexSet, animated: Bool = true) {
    if !animated {
      UIView.performWithoutAnimation {
        self.collectionView!.reloadSections(sections)
      }
    } else {
      collectionView!.reloadSections(sections)
    }
  }

  open override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//    let node = dataSource!.itemAtIndexPath(indexPath: indexPath).node
//    node.component?.didSelectComponents(components: [])


    let new = MCollectionController()
    let cool = CoolComponent()
    cool.expanded = true
    new.appendNewComponents(components: [cool])
    new.useLayoutToLayoutNavigationTransitions = true
    self.navigationController?.pushViewController(new, animated: true)
  }


  open override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
    return true
  }

  open override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
    return true
  }

  open override func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
    print(indexPath)
  }

  open override func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
  }

  open override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    //    displayDelegate?.controller(controller: self, willDisplayItem: indexPath)
  }
}
