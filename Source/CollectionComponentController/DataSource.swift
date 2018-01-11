import Foundation

open class DataSource<T>: NSObject {
  public var data = [[T]]()
  
  public func numberOfSections() -> Int {
    return data.count
  }
  
  public func numberOfItems(in section: Int) -> Int {
    return data[section].count
  }
  
  public func itemAtIndexPath(indexPath: IndexPath) -> T {
    return data[indexPath.section][indexPath.item]
  }
}
