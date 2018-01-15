import Foundation

open class DataSource<T>: NSObject, NSCopying {
  public var data = [[T]]()

  public func copy(with zone: NSZone? = nil) -> Any {
    let new = DataSource<T>()
    new.data = data
    return new
  }
  
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
