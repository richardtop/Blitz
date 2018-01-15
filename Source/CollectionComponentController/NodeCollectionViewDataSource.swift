import UIKit

 open class NodeCollectionViewDataSource: DataSource<Subnode>, UICollectionViewDataSource {
   open func numberOfSections(in collectionView: UICollectionView) -> Int {
    return numberOfSections()
  }
  
   open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return numberOfItems(in: section)
  }
  
   open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let subnode = itemAtIndexPath(indexPath: indexPath)
    let viewType = subnode.node.viewType
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: viewType!),
                                                  for: indexPath)
    if let cell = cell as? NodeUpdatable {
      cell.update(node: subnode.node)
    }

    return cell
  }
  
   open func setSubnode(subnode: Subnode, at indexPath: IndexPath) {
    data[indexPath.section][indexPath.item] = subnode
  }
  
   open func setSubnodes(subnodes: [Subnode], at section: Int) {
    data[section] = subnodes
  }
  
   open func append(sections: [[Subnode]]) {
    data.append(contentsOf: sections)
  }
}
