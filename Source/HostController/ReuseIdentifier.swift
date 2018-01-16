import UIKit

public protocol ReusableCell {
  static func reuseIdentifier() -> String
}

extension ReusableCell {
  public static func reuseIdentifier() -> String {
    return String(describing: self)
  }
}

extension UICollectionReusableView: ReusableCell {}

public extension UICollectionView {
  func registerClass(_ cellClass: UICollectionViewCell.Type) {
    register(cellClass, forCellWithReuseIdentifier: cellClass.reuseIdentifier())
  }

  func registerClasses(_ classes: [UICollectionViewCell.Type]) {
    classes.forEach{
     registerClass($0)
    }
  }
}
