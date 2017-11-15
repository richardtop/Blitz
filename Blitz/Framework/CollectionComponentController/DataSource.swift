import Foundation

class DataSource<T>: NSObject {
  var data = [[T]]()
  
  func numberOfSections() -> Int {
    return data.count
  }
  
  func numberOfItems(in section: Int) -> Int {
    return data[section].count
  }
  
  func itemAtIndexPath(indexPath: IndexPath) -> T {
    return data[indexPath.section][indexPath.item]
  }
}
