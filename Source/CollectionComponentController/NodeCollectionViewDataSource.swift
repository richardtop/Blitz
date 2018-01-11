import UIKit

public class NodeCollectionViewDataSource: DataSource<Subnode>, UICollectionViewDataSource {
  public func numberOfSections(in collectionView: UICollectionView) -> Int {
    return numberOfSections()
  }
  
  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return numberOfItems(in: section)
  }
  
  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let subnode = itemAtIndexPath(indexPath: indexPath)
    let viewType = subnode.node.viewType
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: viewType!),
                                                  for: indexPath)
    if let cell = cell as? NodeUpdatable {
      cell.update(node: subnode.node)
    }

    return cell
  }
  
  func setSubnode(subnode: Subnode, at indexPath: IndexPath) {
    data[indexPath.section][indexPath.item] = subnode
  }
  
  func setSubnodes(subnodes: [Subnode], at section: Int) {
    data[section] = subnodes
  }
  
  func append(sections: [[Subnode]]) {
    data.append(contentsOf: sections)
  }
}
